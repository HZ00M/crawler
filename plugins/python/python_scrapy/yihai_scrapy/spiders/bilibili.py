import json
import logging
import re
import time

import scrapy

from yihai_scrapy import Util
# from yihai_scrapy.items import NeonScrapyCommentItem
from yihai_scrapy.items import NeonScrapyItem
from yihai_scrapy.page import bilibiliPage as Page
from yihai_scrapy.config import scrapy_config
from yihai_scrapy.config import req_config
from yihai_scrapy.config import url_config
from datetime import datetime
import logging


# from yihai_scrapy import logger
# import random

# ---1 导入分布式爬虫类
# from scrapy_redis.spiders import RedisSpider


# user_card = ["https://api.bilibili.com/x/web-interface/card?mid=163769640&photo=true&web_location=333.788"]

# ---2 继承分布式爬虫类
class BilibiliSpider(scrapy.Spider):
    # class BilibiliSpider(RedisSpider):
    name = "bilibili"
    # ---3 注释掉start_url&allowed_domains
    allowed_domains = ["bilibili.com", "biligame.com"]
    start_urls = []

    # ---4 设置redis-key
    # redis_key = "bilibili_key"

    not_req_list = {}
    req_index = 1

    def __init__(self, key_word="", execute_id=0, execute_name="", ignore_word="", begin_time=0, end_time=0, *args,
                 **kwargs):
        logging.info(kwargs)
        # domain = kwargs.pop('domain', '')
        # self.allowed_domains = list(filter(None, domain.split(',')))
        super(BilibiliSpider, self).__init__(*args, **kwargs)

        # super().__init__(**kwargs)
        temp = req_config["cookies"]
        self.cookies = {data.split('=')[0]: data.split('=')[1] for data in temp.split('; ')}
        self.key_word = key_word
        self.execute_id = int(execute_id)
        self.execute_name = execute_name
        self.ignore_word = ignore_word.split(';') if ignore_word else []
        if begin_time:
            self.start_time = int(begin_time)
        else:
            self.start_time = int(time.time()) - 86400 * 4
        if end_time:
            self.end_time = int(end_time)
        else:
            self.end_time = int(time.time())
        # 添加起始url地址
        if key_word in scrapy_config:
            config = scrapy_config[key_word]
            key_word = Util.pagination_str_req(key_word)
            # 视频
            if config["video"]:
                url_info = {"config": config}
                if config["sort_type"] == "1":
                    url_info["url"] = url_config["video"]["init_page"].format(keyword=key_word, page="1", num=0,
                                                                              begin_time=self.start_time,
                                                                              end_time=self.end_time)
                elif config["sort_type"] == "2":
                    url_info["url"] = url_config["video"]["init_page"].format(keyword=key_word,
                                                                              page="1", num=0,
                                                                              begin_time=self.start_time,
                                                                              end_time=self.end_time) + "&order=pubdate"
                else:
                    logging.info(f"config sort_type error, keyword:{config['name']}")
                    return
                url_info["scrapy_type"] = "video"
                url_info["page"] = 1
                url_info["num"] = 0
                self.start_urls.append(url_info)
            # 专栏
            if config["article"]:
                url_info = {"config": config}
                if config["sort_type"] == "1":
                    url_info["url"] = url_info["url"] = url_config["article"]["init_page"].format(keyword=key_word,
                                                                                                  page="1")
                elif config["sort_type"] == "2":
                    url_info["url"] = url_info["url"] = url_config["article"]["init_page"].format(keyword=key_word,
                                                                                                  page="1") + "&order=pubdate"
                else:
                    logging.info(f"config sort_type error, keyword:{config['name']}")
                    return
                url_info["scrapy_type"] = "article"
                self.start_urls.append(url_info)
            # 动态
            if config["dynamic"]:
                url_info = {"config": config}
                # url_info["url"] = url_config["dynamic"]["init_page"].format(offset="", host_mid=config['UID'])
                url_info["url"] = url_config["dynamic"]["entrance"].format(host_mid=config['UID'])
                url_info["scrapy_type"] = "dynamic"
                url_info["UID"] = config['UID']
                self.start_urls.append(url_info)
            # 游戏中心
            if config["biliGame"]:
                url_info = {"config": config}
                url_info["url"] = url_config["biliGame"]["detail_page"].format(id=config["gameId"])
                url_info["scrapy_type"] = "biliGame"
                self.start_urls.append(url_info)
        else:
            logging.info("keyword not exist in config.py")

    def start_requests(self):
        logging.info(self.start_urls)
        for url_info in self.start_urls:
            req = scrapy.Request(url=url_info["url"],
                                 callback=self.parse,
                                 meta={'url_info': url_info, "req_index": BilibiliSpider.req_index},
                                 # req_config=self.req_config
                                 # dont_filter=True
                                 )
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req

    # 总入口
    def parse(self, response):
        # 视频列表
        # with open('bilibili.html', 'w', encoding='utf-8') as f:
        #     f.write(response.text)
        #     f.close()
        # logging.info(response.body)
        # 根据url_type,执行不同的操作
        url_info = response.meta["url_info"]
        url_type = url_info["scrapy_type"]
        config = url_info["config"]
        logging.info(f"url_type : {url_type}")
        # 视频
        if url_type == "video":
            item_lists = response.xpath(Page.video_list)
            logging.info(type(item_lists))
            if item_lists:
                item_list = []
                for item in item_lists:
                    video_item = NeonScrapyItem()
                    video_item['title'] = item.xpath(Page.video_title).extract_first()
                    video_item['record_ur'] = "https:" + item.xpath(Page.video_details).extract_first()
                    item_list.append(video_item)
                req = scrapy.Request(url=item_list[0]['record_ur'], callback=self.get_video_details,
                                     meta={'video_item': item_list[0], "item_list": item_list, "item_index": 1,
                                           'url_info': url_info, "req_index": BilibiliSpider.req_index},
                                     # req_config=self.req_config,
                                     dont_filter=True)
                BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                BilibiliSpider.req_index += 1
                yield req
            else:
                logging.info("未定位到视频主页面信息")
        # 专栏的
        elif url_type == "article":
            # 获取专栏主页的
            script_content = response.xpath(Page.article_list).extract_first()
            # 通过正则，获取所有的专栏唯一id
            article_list = self.extract_json_from_html(script_content)
            if article_list:
                item_list = []
                for article_id in article_list:
                    article_item = NeonScrapyItem()
                    # url = f"https://www.bilibili.com/read/cv{article_id}/?from=search&spm_id_from=333.337.0.0"
                    url = url_config["article"]["detail_page"].format(article_id=article_id)
                    article_item["record_ur"] = url
                    article_item["target_obj_id"] = article_id
                    item_list.append(article_item)
                req = scrapy.Request(url=item_list[0]['record_ur'], callback=self.get_article_details,
                                     meta={'article_item': item_list[0], "item_list": item_list, "item_index": 1,
                                           'url_info': url_info, "req_index": BilibiliSpider.req_index},
                                     # req_config=self.req_config,
                                     dont_filter=True)
                BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                BilibiliSpider.req_index += 1
                yield req
            else:
                logging.info("article_list is None")
        # 动态的
        elif url_type == "dynamic":
            url_info["url"] = url_config["dynamic"]["init_page"].format(offset="", host_mid=config['UID'])
            headers = {"referer": None}
            logging.info(self.cookies)
            # 这里不能走随机请求头，不然会判定失败（大部分随机请求头对这个接口来说有点老，但是其他接口没事）
            req = scrapy.Request(url=url_info["url"],
                                 callback=self.get_dynamic_init_page,
                                 meta={'url_info': url_info, "randomProxy": False,
                                       "req_index": BilibiliSpider.req_index},
                                 cookies=self.cookies,
                                 dont_filter=True,
                                 # headers=headers
                                 )
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req
        elif url_type == "biliGame":
            resp_json = json.loads(response.body)
            if resp_json["code"] != 0:
                logging.info("get biliGame comment error")
                return
            biliGame_item = NeonScrapyItem()
            biliGame_item["data_type"] = "游戏中心"
            # 视频id
            biliGame_item["target_obj_id"] = config["gameId"]
            # 游戏简介
            biliGame_item["content"] = resp_json["data"]["desc"]
            # 游戏标签
            biliGame_item["title"] = resp_json["data"]["title"]
            # 开发者的话
            biliGame_item["developer_word"] = resp_json["data"]["dev_introduction"]
            # 安卓最近更新
            biliGame_item["android_last_update"] = resp_json["data"]["android_latest_update"]
            # ios最近更新
            biliGame_item["ios_last_update"] = resp_json["data"]["ios_latest_update"]
            # 标签
            biliGame_item["tag"] = [tag["name"] for tag in resp_json["data"]["tag_list"]]
            logging.info("详情信息拿完，去拿评论数量和评分")
            url = url_config["biliGame"]["summary_page"]
            request_id = Util.generate_random_string()
            ts = int(time.time() * 1000)
            url_sign = url_config["biliGame"]["summer_sign"].format(appkey=url_info["config"]["app_key"],
                                                                    game_base_id=url_info["config"]["gameId"],
                                                                    request_id=request_id,
                                                                    ts=ts)
            sign = Util.biligame_comment_decryption(url_sign)
            url += url_sign + "&sign=" + sign
            req = scrapy.Request(url=url, callback=self.get_biligame_summer,
                                 meta={"biliGame_item": biliGame_item, "url_info": url_info,
                                       "req_index": BilibiliSpider.req_index},
                                 dont_filter=True)
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req
        else:
            logging.info(f"url type error,type:{url_type}")

    # 获取视频详情界面（播放界面）
    def get_video_details(self, response):
        # with open('bilibili.html','w',encoding='utf-8') as f:
        #     f.write(response.text)
        #     f.close()
        video_item = response.meta['video_item']
        item_list = response.meta["item_list"]
        item_index = response.meta["item_index"]
        url_info = response.meta["url_info"]
        video_item['data_type'] = "视频"
        # 视频发布时间
        video_item['msg_time'] = response.xpath(Page.posted_time).extract_first()
        # 如果发布时间不满足筛选需要，结束
        # 转换为 datetime 对象
        dt = datetime.strptime(video_item['msg_time'], "%Y-%m-%d %H:%M:%S")
        # 转换为时间戳
        timestamp = int(time.mktime(dt.timetuple()))
        # if not self.check_time(timestamp):
        if timestamp < self.start_time:
            logging.info(f"发布时间：{timestamp} out of range start_time:{self.start_time},end_time:{self.end_time}")
            return
        # 发布时间满足筛选需求，就继续去遍历下一个视频
        if len(item_list) > item_index:
            logging.info("next video")
            next_video_item = item_list[item_index]
            logging.info(len(item_list))
            logging.info(next_video_item['record_ur'])
            req = scrapy.Request(url=next_video_item['record_ur'], callback=self.get_video_details,
                                 meta={'video_item': next_video_item, "item_list": item_list, 'url_info': url_info,
                                       "item_index": item_index + 1, "req_index": BilibiliSpider.req_index},
                                 # req_config=self.req_config,
                                 dont_filter=True)
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req
        # 如果没有下一页，则去拿
        else:
            logging.info("next page")
            url_info["url"] = url_info["url"].replace(f"page={url_info['page']}",
                                                      f"page={url_info['page'] + 1}").replace(f"&o={url_info['num']}",
                                                                                              f"&o={url_info['num'] + len(item_list)}")
            url_info['page'] += 1
            url_info["num"] += len(item_list)
            req = scrapy.Request(url=url_info["url"],
                                 callback=self.parse,
                                 meta={'url_info': url_info,
                                       "req_index": BilibiliSpider.req_index},
                                 # req_config=self.req_config
                                 )
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req
        if timestamp > self.end_time:
            logging.info(f"发布时间：{timestamp} out of range start_time:{self.start_time},end_time:{self.end_time}")
            return
        # yield video_item
        for ignore in self.ignore_word:
            if ignore in video_item["title"]:
                logging.info(f"视频标题：{video_item['title']}含有屏蔽字：{ignore},跳过")
                return
        # return
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
        # 视频评论数
        # video_item['comments_count'] = response.xpath(Page.video_comment_num).extract_first()
        # 视频三连数量定位
        video_info = response.xpath(Page.video_heat).extract_first()
        # video_info = video_info.split("尽在哔哩哔哩bilibili ")[-1].split(", 视频作者")[0] # 这种有时候取不到，可能是有些视频违规，不能分享，所以分享信息里没有关键字
        video_info = "视频播放量 " + video_info.split("视频播放量 ")[-1].split(", 视频作者")[0]
        info_list = video_info.split("、")
        # 视频播放量/弹幕量/点赞数/投币数/收藏人数/转发人数
        video_config = {"视频播放量": "read_count", "弹幕量": "barrage_count", "点赞数": "like_count",
                        "投硬币枚数": "coin_count", "收藏人数": "mark_count", "转发人数": "share_count"}
        for info in info_list:
            key, value = info.split(" ")
            video_item[video_config[key]] = value
        # 主界面的内容抓完，开始构造评论的抓取
        # 正则获取视频唯一标识oid，后续获取评论要用
        matches = re.findall(r'oid=(\d+)', response.text)
        if matches:
            oid = matches[0]
            video_item["target_obj_id"] = oid
            # url = f"https://api.bilibili.com/x/web-interface/card?mid={video_item['user_id']}&photo=true&web_location=333.788"
            # req = scrapy.Request(url=url, callback=self.get_user_card,
            #                      meta={'item': video_item, "req_index": BilibiliSpider.req_index},
            #                      dont_filter=True)
            # BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            # BilibiliSpider.req_index += 1
            # yield req
        else:
            logging.info("未找到 oid")
            yield video_item
            return

        logging.info(f"------------------- 视频{oid}详情页抓完了，开始抓评论 ------------------------")

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
                                   "randomProxy": False,
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

        # 如果是首页，并且传了视频对象，获取完视频评论数量后，就返回视频数据
        if response.meta["first_page"] and "video_item" in response.meta:
            video_item = response.meta["video_item"]
            video_item['comments_count'] = data["cursor"]["all_count"]
            # 总互动量(三连+转发+评论+弹幕)
            video_item["active_count"] = 0
            self.get_active_count(video_item)
            url = f"https://api.bilibili.com/x/web-interface/card?mid={video_item['user_id']}&photo=true&web_location=333.788"
            req = scrapy.Request(url=url, callback=self.get_user_card,
                                 meta={'item': video_item, "req_index": BilibiliSpider.req_index},
                                 dont_filter=True)
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req
        # up主id
        # upper_id = data["upper"]["mid"]
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
            logging.info("no next page return")
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
                                 meta={'oid': oid, 'first_page': False, "type": comment_type, "randomProxy": False,
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
        url = f"https://api.bilibili.com/x/web-interface/card?mid={comment_item['user_id']}&photo=true&web_location=333.788"
        req_index = BilibiliSpider.req_index
        BilibiliSpider.req_index += 1
        req = scrapy.Request(url=url, callback=self.get_user_card,
                             meta={'item': comment_item, "req_index": req_index},
                             # meta={'item': comment_item},
                             dont_filter=True)
        BilibiliSpider.not_req_list[req_index] = req
        # BilibiliSpider.req_index += 1
        return req

    # 获取用户名片（评论人信息）
    def get_user_card(self, response):
        item = response.meta["item"]
        resp_json = json.loads(response.body)
        if resp_json["code"] != 0:
            logging.info("get user card error")
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
            logging.info("get user card error")
            return
        data = resp_json["data"]
        if data["replies"]:
            for sub_reply in data["replies"]:
                yield self.get_single_reply(sub_reply, reply_type="子评论", oid=response.meta['oid'])

    # 处理专栏详情界面
    def get_article_details(self, response):
        article_item = response.meta["article_item"]
        item_list = response.meta["item_list"]
        item_index = response.meta["item_index"]
        url_info = response.meta["url_info"]
        # 数据类型
        article_item["data_type"] = "专栏"
        # 专栏的所有信息字符串
        article_html_info = response.xpath(Page.article_html_info).extract_first()
        article_html_json = re.findall(r"window.__INITIAL_STATE__=(.*);\(function\(\)", article_html_info)
        if article_html_json:
            article_html_json = json.loads(article_html_json[0])
            # 专栏发布时间
            article_item["msg_time"] = article_html_json["readInfo"]["publish_time"]
            if not self.check_time(int(article_item["msg_time"])):
                logging.info(
                    f"发布时间：{article_item['msg_time']} out of range start_time:{self.start_time},end_time:{self.end_time}")
                return
                # 发布时间满足筛选需求，就继续去遍历下一个专栏
            if len(item_list) > item_index:
                logging.info("next article")
                next_video_item = item_list[item_index]
                req = scrapy.Request(url=next_video_item['record_ur'], callback=self.get_article_details,
                                     meta={'article_item': next_video_item, "item_list": item_list,
                                           'url_info': url_info,
                                           "item_index": item_index + 1, "req_index": BilibiliSpider.req_index},
                                     # req_config=self.req_config,
                                     dont_filter=True)
                BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                BilibiliSpider.req_index += 1
                yield req
            # 如果没有下一页，则去拿
            else:
                logging.info("next page")
                url_info["url"] = url_info["url"].replace(f"page={url_info['page']}",
                                                          f"page={url_info['page'] + 1}")
                url_info['page'] += 1
                req = scrapy.Request(url=url_info["url"],
                                     callback=self.parse,
                                     meta={'url_info': url_info, "req_index": BilibiliSpider.req_index},
                                     # req_config=self.req_config
                                     )
                BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                BilibiliSpider.req_index += 1
                yield req

            # 专栏标题
            article_item["data_type"] = article_html_json["readInfo"]["title"]
            # 专栏发布人
            article_item["author"] = article_html_json["readInfo"]["author"]["name"]
            # 专栏浏览量
            article_item["read_count"] = article_html_json["readInfo"]["stats"]["view"]
            # 专栏点赞量
            article_item["like_count"] = article_html_json["readInfo"]["stats"]["like"]
            # 专栏评论量
            article_item["comments_count"] = article_html_json["readInfo"]["stats"]["reply"]
            # 专栏收藏量
            article_item["mark_count"] = article_html_json["readInfo"]["stats"]["favorite"]
            # 专栏投币量
            article_item["coin_count"] = article_html_json["readInfo"]["stats"]["coin"]
            # 专栏转发人数
            article_item["share_count"] = article_html_json["readInfo"]["stats"]["share"]
            # 专栏互动量（三连+转发+评论）
            article_item["active_count"] = 0
            self.get_active_count(article_item)
            # 专栏标签
            if "tags" in article_html_json["readInfo"]:
                tag_list = article_html_json["readInfo"]["tags"]
                article_item["tag"] = [item["name"] for item in tag_list]
            # 专栏up主用户id
            article_item["user_id"] = article_html_json["readInfo"]["author"]["mid"]
            url = f"https://api.bilibili.com/x/web-interface/card?mid={article_item['user_id']}&photo=true&web_location=333.788"
            req = scrapy.Request(url=url, callback=self.get_user_card,
                                 meta={'item': article_item, "req_index": BilibiliSpider.req_index},
                                 dont_filter=True)
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req
            logging.info("专栏界面基础信息拿完，开始拿评论")
            first_page_pagination_str = {"offset": ""}
            pagination_str = Util.pagination_str(first_page_pagination_str)
            # 构造时间戳
            wts = int(time.time())
            temp = [
                "mode=3",
                f"oid={article_item['target_obj_id']}",
                f"pagination_str={pagination_str}",
                "plat=1",
                "seek_rpid=",
                "type=12",
                "web_location=1315875",
                f"wts={wts}",
            ]
            w_rid = Util.comment_decryption("&".join(temp))
            url = "https://api.bilibili.com/x/v2/reply/wbi/main?" + "&".join(temp) + f"&w_rid={w_rid}"
            logging.info(url)
            req = scrapy.Request(url=url, callback=self.get_video_comment,
                                 meta={'oid': article_item['target_obj_id'], 'first_page': True, "type": 12,
                                       "req_index": BilibiliSpider.req_index},
                                 cookies=self.cookies,
                                 dont_filter=True)
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req
        else:
            logging.info("article_html_json is None")
        # # 发布时间
        # article_item['发布时间'] = response.xpath(Page.posted_time).extract_first()

    def extract_json_from_html(self, html_content):
        matches = re.findall(r'searchTypeResponse\s*(.*})}\s*\(', html_content)
        if matches:
            # todo 这里因为没办法转json,数据提取比较暴力，后面优化
            id_list = re.findall(r',id:\s*(\w+),', matches[0])
            if id_list:
                return id_list
            return None
        else:
            logging.info("正则提取页面数据失败")
            return None

    def get_dynamic_init_page(self, response):
        url_info = response.meta["url_info"]
        config = response.meta["url_info"]["config"]
        resp_json = json.loads(response.body)
        if resp_json["code"] != 0:
            logging.info(resp_json)
            logging.info("get dynamic comment error")
            return
        # 动态的数据，在主界面就能全拿完，拿完直接去拿评论
        for dynamic_info in resp_json["data"]["items"]:
            dynamic_item = self.get_dynamic_details(dynamic_info, url_info["UID"])
            # 如果不满足条件，直接就结束循环
            # if not self.check_time(int(dynamic_item["msg_time"])):
            if self.end_time < int(dynamic_item["msg_time"]):
                logging.info(
                    f"发布时间：{dynamic_item['msg_time']} >end_time,continue,start_time:{self.start_time},end_time:{self.end_time}")
                continue
            elif self.start_time > int(dynamic_item["msg_time"]):
                logging.info(
                    f"发布时间：{dynamic_item['msg_time']} out of range start_time:{self.start_time},end_time:{self.end_time}")
                return
            url = f"https://api.bilibili.com/x/web-interface/card?mid={dynamic_item['user_id']}&photo=true&web_location=333.788"
            req = scrapy.Request(url=url, callback=self.get_user_card,
                                 meta={'item': dynamic_item, "req_index": BilibiliSpider.req_index},
                                 dont_filter=True)
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req
            logging.info("开始抓评论")
            oid = dynamic_item["target_obj_id"]
            dynamic_type = dynamic_info["basic"]["comment_type"]
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
                f"type={dynamic_type}",
                "web_location=1315875",
                f"wts={wts}",
            ]
            w_rid = Util.comment_decryption("&".join(temp))
            url = "https://api.bilibili.com/x/v2/reply/wbi/main?" + "&".join(temp) + f"&w_rid={w_rid}"
            logging.info(url)
            req = scrapy.Request(url=url, callback=self.get_video_comment,
                                 meta={'oid': oid, 'first_page': True, "type": dynamic_type,
                                       "req_index": BilibiliSpider.req_index},
                                 cookies=self.cookies,
                                 dont_filter=True)
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req
        if "offset" in resp_json["data"]:
            logging.info("开始下一页")
            offset = resp_json["data"]["offset"]
            url_info["url"] = url_config["dynamic"]["init_page"].format(offset=offset, host_mid=config['UID'])
            headers = {"referer": None}
            req = scrapy.Request(url=url_info["url"],
                                 callback=self.get_dynamic_init_page,
                                 meta={'url_info': url_info, "randomProxy": False,
                                       "req_index": BilibiliSpider.req_index},
                                 cookies=self.cookies,
                                 dont_filter=True,
                                 headers=headers
                                 )
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req

    # 处理动态详情界面
    def get_dynamic_details(self, dynamic_info, uid):
        dynamic_item = NeonScrapyItem()
        url = url_config["dynamic"]["detail_page"].format(id=dynamic_info["id_str"])
        # 数据地址
        dynamic_item["record_ur"] = url
        dynamic_item["target_obj_id"] = dynamic_info["basic"]["comment_id_str"]
        # 数据类型
        dynamic_item["data_type"] = "动态"
        # 动态发布时间
        dynamic_item["msg_time"] = dynamic_info["modules"]["module_author"]["pub_ts"]
        # 动态标题,根据动态类型，从不同路径下拿标题
        # todo 这里可能会报错，有问题后面再优化，规则有点绕
        # 标题和正文内容
        if dynamic_info["modules"]["module_dynamic"]["major"]:
            if "archive" in dynamic_info["modules"]["module_dynamic"]["major"]:
                dynamic_item["title"] = dynamic_info["modules"]["module_dynamic"]["major"]["archive"]["title"]
                dynamic_item["content"] = dynamic_info["modules"]["module_dynamic"]["major"]["archive"]["desc"]
            elif "article" in dynamic_info["modules"]["module_dynamic"]["major"]:
                dynamic_item["title"] = dynamic_info["modules"]["module_dynamic"]["major"]["article"]["title"]
                dynamic_item["content"] = dynamic_info["modules"]["module_dynamic"]["major"]["article"]["desc"]
            elif "opus" in dynamic_info["modules"]["module_dynamic"]["major"]:
                dynamic_item["title"] = dynamic_info["modules"]["module_dynamic"]["major"]["opus"]["title"]
                dynamic_item["content"] = dynamic_info["modules"]["module_dynamic"]["major"]["opus"]["summary"]["desc"]
            else:
                dynamic_item["title"] = ""
                dynamic_item["content"] = ""
        elif dynamic_info["modules"]["module_dynamic"]["desc"]:
            dynamic_item["content"] = dynamic_info["modules"]["module_dynamic"]["desc"]["text"]
            dynamic_item["title"] = ""
        else:
            dynamic_item["content"] = ""
            dynamic_item["title"] = ""
        # 动态发布人
        dynamic_item["author"] = dynamic_info["modules"]["module_author"]["name"]
        # 动态点赞量
        dynamic_item["like_count"] = dynamic_info["modules"]["module_stat"]["like"]["count"]
        # 动态评论量
        dynamic_item["comments_count"] = dynamic_info["modules"]["module_stat"]["comment"]["count"]
        # 专栏转发量
        dynamic_item["share_count"] = dynamic_info["modules"]["module_stat"]["forward"]["count"]
        # 专栏互动量（没有投币和收藏？）
        dynamic_item["active_count"]=0
        self.get_active_count(dynamic_item)
        # 专栏up主用户id
        dynamic_item["user_id"] = uid
        return dynamic_item

    # 获取游戏中心评分，评论数
    def get_biligame_summer(self, response):
        resp_json = json.loads(response.body)
        if resp_json["code"] != 0:
            logging.info("get biligame_summer error")
            return
        biliGame_item = response.meta["biliGame_item"]
        # 游戏评分
        biliGame_item["mark"] = resp_json["data"]["grade"]
        # 游戏评论数
        biliGame_item["comments_count"] = resp_json["data"]["comment_number"]
        url = url_config["biliGame"]["game_info"].format(id=response.meta["url_info"]["config"]["gameId"])
        req = scrapy.Request(url=url, callback=self.get_biligame_gameinfo,
                             meta={"biliGame_item": biliGame_item, "url_info": response.meta["url_info"],
                                   "req_index": BilibiliSpider.req_index},
                             dont_filter=True)
        BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
        BilibiliSpider.req_index += 1
        yield req

    # 获取游戏下载量，预约量
    def get_biligame_gameinfo(self, response):
        resp_json = json.loads(response.body)
        if resp_json["code"] != 0:
            logging.info("get biligame_gameinfo error")
            return
        biliGame_item = response.meta["biliGame_item"]
        oid = biliGame_item["target_obj_id"]
        url_info = response.meta["url_info"]
        # 游戏下载量
        biliGame_item["download_count"] = resp_json["data"]["download_count"]
        # 游戏预约量
        if "book_num" in resp_json["data"]:
            biliGame_item["book_num"] = resp_json["data"]["book_num"]
        yield biliGame_item
        logging.info("游戏中心基础数据拿完了，开始拿评论")
        comment_count = biliGame_item["comments_count"]
        url = url_config["biliGame"]["replay_page"]
        page_index = 1
        # 循环去拿，直到评论被拿完
        # while comment_count > 0:
        request_id = Util.generate_random_string()
        ts = int(time.time() * 1000)
        reply_sign = url_config["biliGame"]["reply_sign"].format(game_base_id=url_info["config"]["gameId"],
                                                                 rank_type=url_info["config"]["sort_type"],
                                                                 page_num=page_index, ts=ts,
                                                                 request_id=request_id,
                                                                 appkey=url_info["config"]["app_key"])
        sign = Util.biligame_comment_decryption(reply_sign)
        req_url = url + reply_sign + "&sign=" + sign
        req = scrapy.Request(url=req_url, callback=self.get_biligime_comment,
                             meta={"url_info": response.meta["url_info"],
                                   "page_index": page_index, "comment_count": comment_count - 10, "oid": oid,
                                   "req_index": BilibiliSpider.req_index},
                             dont_filter=True)
        BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
        BilibiliSpider.req_index += 1
        yield req
        # comment_count -= 1000
        # page_index += 1

    def get_biligime_comment(self, response):
        resp_json = json.loads(response.body)
        if resp_json["code"] != 0:
            logging.info("get biligime comment error")
            return
        data = resp_json["data"]
        url_info = response.meta["url_info"]
        oid = response.meta["oid"]
        # 每一页的评论内容
        # print(data)
        for comment in data["list"]:
            # 获取评论内容
            comment_item = self.get_biligame_single_reply(comment, oid=oid)
            dt = datetime.strptime(comment_item['comment_time'], "%Y-%m-%d %H:%M:%S")
            # 转换为时间戳
            timestamp = int(time.mktime(dt.timetuple()))
            if timestamp > self.end_time:
                logging.info("小于开始时间，continue")
                continue
            if timestamp < self.start_time:
                logging.info("超过开始时间，停止抓取")
                return
            # if not self.check_time(timestamp):
            #     return
            logging.info("去拿用户信息")
            url = f"https://api.bilibili.com/x/web-interface/card?mid={comment_item['user_id']}&photo=true&web_location=333.788"
            req = scrapy.Request(url=url, callback=self.get_user_card,
                                 meta={'item': comment_item, "req_index": BilibiliSpider.req_index},
                                 dont_filter=True)
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req
            # 判断评论是否有子评论
            sub_reply_num = int(comment["reply_count"])
            comment_no = comment["comment_no"]
            # 如果子评论大于0，要额外调接口去拿
            logging.info("调接口开始拿子评论")
            url = url_config["biliGame"]["sub_replay_page"]
            page_index = 1
            # 循环去拿，直到评论被拿完
            while sub_reply_num > 0:
                request_id = Util.generate_random_string()
                ts = int(time.time() * 1000)
                reply_sign = url_config["biliGame"]["sub_reply_sign"].format(game_base_id=url_info["config"]["gameId"],
                                                                             comment_no=comment_no,
                                                                             page_num=page_index, ts=ts,
                                                                             request_id=request_id,
                                                                             appkey=url_info["config"]["app_key"])
                sign = Util.biligame_comment_decryption(reply_sign)
                req_url = url + reply_sign + "&sign=" + sign
                req = scrapy.Request(url=req_url, callback=self.get_sub_biligame_comment,
                                     meta={"url_info": response.meta["url_info"],
                                           "page_index": page_index, "oid": oid, "req_index": BilibiliSpider.req_index},
                                     dont_filter=True)
                BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                BilibiliSpider.req_index += 1
                yield req
                sub_reply_num -= 10
                page_index += 1
        page_index = response.meta["page_index"] + 1
        comment_count = response.meta["comment_count"]
        if comment_count > 0:
            request_id = Util.generate_random_string()
            ts = int(time.time() * 1000)
            url = url_config["biliGame"]["replay_page"]
            reply_sign = url_config["biliGame"]["reply_sign"].format(game_base_id=url_info["config"]["gameId"],
                                                                     rank_type=url_info["config"]["sort_type"],
                                                                     page_num=page_index, ts=ts,
                                                                     request_id=request_id,
                                                                     appkey=url_info["config"]["app_key"])
            sign = Util.biligame_comment_decryption(reply_sign)
            req_url = url + reply_sign + "&sign=" + sign
            req = scrapy.Request(url=req_url, callback=self.get_biligime_comment,
                                 meta={"url_info": response.meta["url_info"],
                                       "page_index": page_index, "comment_count": comment_count - 10,"oid": oid,
                                       "req_index": BilibiliSpider.req_index},
                                 dont_filter=True)
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req

    def get_biligame_single_reply(self, comment, reply_type="评论", oid=""):
        logging.info("----------拿评论ing-----------")
        comment_item = NeonScrapyItem()
        # 类型是评论
        comment_item["data_type"] = reply_type
        # 类型是评论
        comment_item["target_obj_id"] = oid
        # 评论内容
        comment_item["comment"] = comment["content"]
        # 评论人
        comment_item["commenter_name"] = comment["user_name"]
        comment_item["author"] = comment["user_name"]
        # 评论点赞量
        comment_item["like_count"] = comment["up_count"]
        # 评论踩量
        if "down_count" in comment:
            comment_item["down_count"] = comment["down_count"]
        # 评论回复量
        if "reply_count" in comment:
            comment_item["comment_reply_num"] = comment["reply_count"]
        # 评论时间
        comment_item["comment_time"] = comment["publish_time"]
        # 去主页拿评论人的信息
        # 评论人mid
        comment_item["user_id"] = comment["uid"]
        return comment_item
        # logging.info("去拿用户信息")
        # url = f"https://api.bilibili.com/x/web-interface/card?mid={comment_item['user_id']}&photo=true&web_location=333.788"
        # return scrapy.Request(url=url, callback=self.get_user_card, meta={'item': comment_item},
        #                       dont_filter=True)

    def get_sub_biligame_comment(self, response):
        resp_json = json.loads(response.body)
        if resp_json["code"] != 0:
            logging.info("get sub biligame comment error")
            return
        data = resp_json["data"]
        if data["list"]:
            for sub_reply in data["list"]:
                yield self.get_biligame_single_reply(sub_reply, reply_type="子评论", oid=response.meta["oid"])

    # def check_time(self, publish_time, days_ago):
    #     run_time = datetime.fromtimestamp(self.run_time).date()
    #     publish_time = datetime.fromtimestamp(publish_time).date()
    #     return (run_time - publish_time).days <= days_ago

    def check_time(self, publish_time):
        # run_time = datetime.fromtimestamp(self.run_time).date()
        # publish_time = datetime.fromtimestamp(publish_time).date()
        return self.start_time < publish_time < self.end_time

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
