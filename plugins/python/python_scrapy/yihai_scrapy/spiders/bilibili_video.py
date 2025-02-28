import json
import logging
import re
import time
from distutils.command.config import config
# 解决execjs执行js时产生的乱码报错，需要在导入execjs模块之前，让popen的encoding参数锁定为utf-8
import subprocess
from functools import partial

from twisted.python.compat import items

subprocess.Popen = partial(subprocess.Popen, encoding="utf-8")
import execjs

import scrapy
from yihai_scrapy import Util
# from yihai_scrapy.items import NeonScrapyCommentItem
from yihai_scrapy.items import NeonScrapyItem
from yihai_scrapy.page import bilibiliPage as Page
from yihai_scrapy.config import scrapy_config
from yihai_scrapy.config import req_config
from yihai_scrapy.config import url_config
from yihai_scrapy.config import redis_config
from yihai_scrapy.cookies import ScrapyCookies
from datetime import datetime
import logging
import redis


# from yihai_scrapy import logger
# import random

# ---1 导入分布式爬虫类
# from scrapy_redis.spiders import RedisSpider


# user_card = ["https://api.bilibili.com/x/web-interface/card?mid=163769640&photo=true&web_location=333.788"]

# ---2 继承分布式爬虫类
class BilibiliSpider(scrapy.Spider):
    # class BilibiliSpider(RedisSpider):
    name = "bilibili_video"
    # ---3 注释掉start_url&allowed_domains
    allowed_domains = ["bilibili.com", "biligame.com"]
    start_urls = []

    # ---4 设置redis-key
    # redis_key = "bilibili_key"

    not_req_list = {}
    req_index = 1

    def __init__(self, key_word="", execute_id=0, execute_name="", ignore_word="", begin_time=0, end_time=0, model=0,
                 project_name="", storage_flag="",
                 *args,
                 **kwargs):
        logging.info(kwargs)
        # domain = kwargs.pop('domain', '')
        # self.allowed_domains = list(filter(None, domain.split(',')))
        super(BilibiliSpider, self).__init__(*args, **kwargs)
        self.redis = redis.StrictRedis(host=redis_config["host"], port=redis_config["port"], db=redis_config["db"],
                                       decode_responses=redis_config["decode_responses"])
        self.bilibili_user_dicts = self.redis.hgetall(redis_config["bilibili"])
        temp = req_config["cookies"]
        logging.info(f"game_cookies:{temp}")
        self.cookies = {data.split('=')[0]: data.split('=')[1] for data in temp.split('; ')}
        logging.error(self.cookies)
        # 传过来的参数，不用处理，写数据的时候，写回去传到数据库就行
        self.project_name = project_name
        self.storage_flag = storage_flag

        self.key_word = key_word
        # 把key_word加入start_urls
        self.start_urls.append(self.key_word)
        self.execute_id = int(execute_id)
        self.execute_name = execute_name
        self.ignore_word = ignore_word.split(';') if ignore_word else []
        # 添加起始url地址

    def start_requests(self):
        logging.info(self.start_urls)
        for url in self.start_urls:
            req = scrapy.Request(url=url,
                                 callback=self.parse,
                                 meta={"req_index": BilibiliSpider.req_index
                                       },
                                 )
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req

    # 总入口
    def parse(self, response):
        video_item = NeonScrapyItem()
        video_item['data_type'] = "视频"
        video_item['title'] = response.xpath(Page.video_title).extract_first()
        # 视频发布时间
        video_item['msg_time'] = response.xpath(Page.posted_time).extract_first()
        # 判断是否有屏蔽字，有屏蔽字的视频不处理
        for ignore in self.ignore_word:
            if ignore in video_item["title"]:
                logging.info(f"视频标题：{video_item['title']}含有屏蔽字：{ignore},跳过")
                return
        # 视频发布人名字
        name = response.xpath(Page.up_name).extract_first()
        # 去掉默认的换行符，空字符
        video_item['author'] = name.replace('\n', '').replace(' ', '')
        up_id = response.xpath(Page.up_id).extract_first()
        video_item['user_id'] = re.findall(r'(\d+)', up_id)[0]
        # 视频简介
        video_item['content'] = response.xpath(Page.video_introduction).extract_first()
        # 视频标签
        # 过滤掉空节点（视频话题，或者音乐该节点为空）
        video_item['tag'] = response.xpath(Page.video_tag).extract()
        # 视频话题
        video_item['subject'] = response.xpath(Page.video_topic).extract()
        video_html_info = response.text
        video_html_json = re.findall(r"window.__INITIAL_STATE__=(.*);\(function\(\)", video_html_info)
        if video_html_json:
            try:
                video_json = json.loads(video_html_json[0])
                stat = video_json["videoData"]["stat"]
                video_item['target_obj_id'] = stat["aid"]  # 分析对象id，依赖它去拿评论
                oid = video_item['target_obj_id']
                video_item['comments_count'] = stat["reply"]  # 评论数量
                video_item['read_count'] = stat["view"]  # 视频播放量
                video_item['barrage_count'] = stat["danmaku"]  # 弹幕数
                video_item['like_count'] = stat["like"]  # 点赞数量
                video_item['coin_count'] = stat["coin"]  # 投币数量
                video_item['mark_count'] = stat["favorite"]  # 收藏数量
                video_item['share_count'] = stat["share"]  # 转发数量
                video_item["active_count"] = 0
                self.get_active_count(video_item)
                yield video_item
                # yield self.send_user_card(video_item)
            except Exception as e:
                logging.error(e)
                logging.info(f"获取互动数据失败，req.url:{response.url}")
                yield video_item
                return
        else:
            logging.error(f"提取互动信息失败，video_html_json: {video_html_json}")
            return

        logging.info(f"------------------- 视频{oid}详情页抓完了，开始抓评论 ------------------------")
        if video_item['comments_count'] == 0:
            logging.info(f"一个评论都没有，不用往下抓了,url:{video_item['record_ur']}")
            return

        # 构造首页页签参数pagination_str
        first_page_pagination_str = {"offset": ""}
        pagination_str = Util.pagination_str(first_page_pagination_str)
        # 构造时间戳
        wts = int(time.time())
        temp = [
            "mode=3",
            f"oid={oid}",
            f"pagination_str={pagination_str}",
            "plat=1",
            "seek_rpid=",
            "type=1",
            "web_location=1315875",
            f"wts={wts}",
        ]
        w_rid = Util.comment_decryption("&".join(temp))
        url = "https://api.bilibili.com/x/v2/reply/wbi/main?" + "&".join(temp) + f"&w_rid={w_rid}"
        req = scrapy.Request(url=url, callback=self.get_video_comment,
                             meta={'oid': oid, 'first_page': True, "video_item": video_item, "type": 1,
                                   "randomProxy": True,
                                   "req_index": BilibiliSpider.req_index},
                             cookies=self.cookies,
                             dont_filter=True)
        BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
        BilibiliSpider.req_index += 1
        yield req

    # 获取视频评论
    def get_video_comment(self, response):
        # with open('bilibili.txt', 'w', encoding='utf-8') as f:
        #     f.write(response.text)
        #     f.close()
        comment_type = response.meta["type"]
        resp_json = json.loads(response.body)
        if resp_json["code"] != 0:
            logging.info("get video comment error")
            return
        data = resp_json["data"]

        # 置顶的评论单独放在一个数据里,且只需要首次获取一次
        top_reply = data["top_replies"]
        if top_reply and response.meta["first_page"]:
            for reply in top_reply:
                yield self.get_single_reply(reply, reply_type="置顶评论", oid=response.meta['oid'])
                top_sub_reply_num = int(reply["rcount"])
                if top_sub_reply_num > 0:
                    logging.info("调接口开始拿子评论")
                    # 每次拿10个
                    pn = 1
                    while top_sub_reply_num > 0:
                        temp = [
                            f"oid={response.meta['oid']}",
                            f"type={comment_type}",
                            f"root={reply['rpid']}",
                            "ps=10",
                            f"pn={pn}",
                            "web_location=333.788",
                        ]
                        url = "https://api.bilibili.com/x/v2/reply/reply?" + "&".join(temp)
                        logging.info("开始抓子评论下一页")

                        req = scrapy.Request(url=url, callback=self.get_sub_video_comment,
                                             meta={"oid": response.meta['oid'], "req_index": BilibiliSpider.req_index},
                                             cookies=self.cookies,
                                             dont_filter=True)
                        BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                        BilibiliSpider.req_index += 1
                        yield req
                        pn += 1
                        top_sub_reply_num -= 10
                # 没有回复就不管了
                else:
                    pass
        # 评论内容
        if data["replies"]:
            for comment in data["replies"]:
                # 获取评论内容
                yield self.get_single_reply(comment, oid=response.meta['oid'])
                # 判断评论是否有子评论
                sub_reply_num = int(comment["rcount"])
                # 如果小于3个，直接在本页面就能拿（后面备注：有些一个评论也折叠起来了，看起来可能更像和长度有关）
                # if 0 < sub_reply_num <= 3:
                #     for sub_reply in comment["replies"]:
                #         yield self.get_single_reply(sub_reply, reply_type="子评论")
                # 如果评论大于3个，要额外调接口去拿
                if sub_reply_num > 0:
                    logging.info("调接口开始拿子评论")
                    # 每次拿10个
                    pn = 1
                    while sub_reply_num > 0:
                        temp = [
                            f"oid={response.meta['oid']}",
                            f"type={comment_type}",
                            f"root={comment['rpid']}",
                            "ps=10",
                            f"pn={pn}",
                            "web_location=333.788",
                        ]
                        url = "https://api.bilibili.com/x/v2/reply/reply?" + "&".join(temp)
                        logging.info("开始抓子评论下一页")
                        req = scrapy.Request(url=url, callback=self.get_sub_video_comment,
                                             meta={"oid": response.meta['oid'], "req_index": BilibiliSpider.req_index},
                                             cookies=self.cookies,
                                             dont_filter=True)
                        BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                        BilibiliSpider.req_index += 1
                        yield req
                        pn += 1
                        sub_reply_num -= 10
                # 没有回复就不管了
                else:
                    pass

        # 如果没有下一页，结束循环
        if data["cursor"]["pagination_reply"]:
            next_offset = data["cursor"]["pagination_reply"]["next_offset"] if "next_offset" in data["cursor"][
                "pagination_reply"] else None
        else:
            next_offset = None
        if not next_offset:
            logging.info("reply no next page, return")
            return
        else:
            offset = Util.pagination_str({"offset": next_offset})
            logging.info(offset)
            oid = response.meta['oid']
            wts = int(time.time())
            temp = [
                "mode=3",
                f"oid={oid}",
                f"pagination_str={offset}",
                "plat=1",
                "seek_rpid=",
                f"type={comment_type}",
                "web_location=1315875",
                f"wts={wts}",
            ]
            w_rid = Util.comment_decryption("&".join(temp))
            url = "https://api.bilibili.com/x/v2/reply/wbi/main?" + "&".join(temp) + f"&w_rid={w_rid}"
            logging.info("开始抓评论下一页")
            req = scrapy.Request(url=url, callback=self.get_video_comment,
                                 meta={'oid': oid, 'first_page': False, "type": comment_type, "randomProxy": True,
                                       "req_index": BilibiliSpider.req_index},
                                 cookies=self.cookies,
                                 dont_filter=True)
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req

    # 获取单个评论
    def get_single_reply(self, comment, reply_type="评论", oid=""):
        logging.info("----------拿评论ing-----------")
        comment_item = NeonScrapyItem()
        # 类型是评论
        comment_item["data_type"] = reply_type
        # 类型是评论
        comment_item["target_obj_id"] = oid
        # 评论内容
        comment_item["comment"] = comment["content"]["message"]
        # 评论人
        comment_item["commenter_name"] = comment["member"]["uname"]
        comment_item["author"] = comment["member"]["uname"]
        # 评论点赞量
        comment_item["like_count"] = comment["like"]
        # 评论回复量
        comment_item["comment_reply_num"] = comment["rcount"]
        # 评论时间
        comment_item["comment_time"] = self.timestamp_to_time(comment["ctime"])
        # 去主页拿评论人的信息
        # 评论人mid
        comment_item["user_id"] = comment["member"]["mid"]
        logging.info("去拿用户信息")
        return comment_item
        # return self.send_user_card(comment_item)
        # now_time = int(time.time())
        # user_id = str(comment_item['user_id'])
        # if user_id not in self.bilibili_user_dicts or eval(self.bilibili_user_dicts[user_id])[
        #     "save_time"] < now_time - 86400 * 30:
        #     url = f"https://api.bilibili.com/x/web-interface/card?mid={comment_item['user_id']}&photo=true&web_location=333.788"
        #     req_index = BilibiliSpider.req_index
        #     BilibiliSpider.req_index += 1
        #     req = scrapy.Request(url=url, callback=self.get_user_card,
        #                          meta={'item': comment_item, "req_index": req_index},
        #                          # meta={'item': comment_item},
        #                          dont_filter=True)
        #     BilibiliSpider.not_req_list[req_index] = req
        #     # BilibiliSpider.req_index += 1
        #     return req
        # else:
        #     yield self.get_redis_userinfo(comment_item)

    # 获取用户名片（评论人信息）
    def get_user_card(self, response):
        item = response.meta["item"]
        resp_json = json.loads(response.body)
        if resp_json["code"] != 0:
            logging.info(f"get user card error, return {resp_json}")
            return
        data = resp_json["data"]
        # 用户等级
        item["user_level"] = data["card"]["level_info"]["current_level"]
        # 用户粉丝数
        item["fans_count"] = data["card"]["fans"]
        # 用户关注数
        item["interest_count"] = data["card"]["friend"]
        # 用户获赞数
        item["user_likes"] = data["like_num"]
        # 用户简介
        item["user_describe"] = data["card"]["sign"]
        # 用户会员
        item["user_member"] = data["card"]["vip"]["label"]["text"]
        # 用户主页uirl
        item["user_homepage"] = f"https://space.bilibili.com/{item['user_id']}"
        yield item

    # 获取子评论内容
    def get_sub_video_comment(self, response):
        resp_json = json.loads(response.body)
        if resp_json["code"] != 0:
            logging.info(f"get sub video error, return {resp_json}")
            return
        data = resp_json["data"]
        if data["replies"]:
            for sub_reply in data["replies"]:
                yield self.get_single_reply(sub_reply, reply_type="子评论", oid=response.meta['oid'])

    def timestamp_to_time(self, timestamp):
        # 时间戳单位是秒
        time_tuple = time.localtime(timestamp)
        return time.strftime("%Y-%m-%d %H:%M:%S", time_tuple)

    def get_active_count(self, item):
        if "like_count" in item and item["like_count"]:
            item["active_count"] += int(item["like_count"])
        if "coin_count" in item and item["coin_count"]:
            item["active_count"] += int(item["coin_count"])
        if "share_count" in item and item["share_count"]:
            item["active_count"] += int(item["share_count"])
        if "comments_count" in item and item["comments_count"]:
            item["active_count"] += int(item["comments_count"])
        if "barrage_count" in item and item["barrage_count"]:
            item["active_count"] += int(item["barrage_count"])
        if "mark_count" in item and item["mark_count"]:
            item["active_count"] += int(item["mark_count"])

    # 从redis数据里获取用户信息
    def get_redis_userinfo(self, item):
        # print("11111111111111111111111111111111111111111")
        # print(item["user_id"])
        item_user_info = json.loads(self.bilibili_user_dicts[str(item["user_id"])])
        # print(item_user_info)
        item["user_level"] = item_user_info["user_level"]
        item["fans_count"] = item_user_info["fans_count"]
        item["interest_count"] = item_user_info["interest_count"]
        item["user_likes"] = item_user_info["user_likes"]
        item["user_describe"] = item_user_info["user_describe"]
        item["user_member"] = item_user_info["user_member"]
        item["user_homepage"] = item_user_info["user_homepage"]
        # print(item)
        return item

    def send_user_card(self, item):
        now_time = int(time.time())
        user_id = str(item['user_id'])
        if user_id not in self.bilibili_user_dicts or json.loads(self.bilibili_user_dicts[user_id])[
            "save_time"] < now_time - 86400 * 30:
            url = f"https://api.bilibili.com/x/web-interface/card?mid={item['user_id']}&photo=true&web_location=333.788"
            # headers = {"referer": None}
            req = scrapy.Request(url=url, callback=self.get_user_card,
                                 meta={'item': item, "req_index": BilibiliSpider.req_index},
                                 # headers=headers,
                                 dont_filter=True)
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            # print(222222222222222222222222222222)
            # print(item['user_id'])
            # print(self.bilibili_user_dicts)
            return req
        else:
            return self.get_redis_userinfo(item)

    def get_dict_key(self, lists, keys):
        for dicts in lists:
            if keys in dicts:
                return dicts[keys]
