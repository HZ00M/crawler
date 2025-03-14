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
    name = "bilibili"
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
        # super().__init__(**kwargs)
        # sc = ScrapyCookies("bilibili")
        # sc.update_config_cookies()
        temp = req_config["cookies"]
        logging.info(f"game_cookies:{temp}")
        self.cookies = {data.split('=')[0]: data.split('=')[1] for data in temp.split('; ')}
        # 传过来的参数，不用出来，写数据的时候，写回去传到数据库就行
        self.project_name = project_name
        self.storage_flag = storage_flag

        self.key_word = key_word
        self.execute_id = int(execute_id)
        self.execute_name = execute_name
        # 屏蔽字
        self.ignore_word = ignore_word.split(';') if ignore_word else []
        self.model = int(model)
        # 正常运行
        if self.model == 0:
            self.start_time = int(begin_time)
            self.end_time = int(end_time)
        # 抓取前1天
        elif self.model == 1:
            now = datetime.now()
            # 将当前日期的时间部分设置为 00:00:00
            start_of_day = datetime(now.year, now.month, now.day)
            # 转换为时间戳
            timestamp = int(start_of_day.timestamp())
            self.start_time = timestamp - 86400
            self.end_time = timestamp
        # 抓取前7天
        elif self.model == 2:
            now = datetime.now()
            # 将当前日期的时间部分设置为 00:00:00
            start_of_day = datetime(now.year, now.month, now.day)
            # 转换为时间戳
            timestamp = int(start_of_day.timestamp())
            self.start_time = timestamp - 86400 * 7
            self.end_time = timestamp
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
            key_word = Util.pagination_str_req(key_word)
            # 视频
            url_info = {}
            url = "https://search.bilibili.com/video?vt=14663435&keyword={keyword}&pubtime_begin_s={begin_time}&pubtime_end_s={end_time}&page={page}&o={num}"
            url_info["url"] = url.format(keyword=key_word,
                                         page="1", num=0,
                                         begin_time=self.start_time,
                                         end_time=self.end_time) + "&order=pubdate"
            url_info["scrapy_type"] = "video"
            url_info["page"] = 1
            url_info["num"] = 0
            # print(url_info)
            # print(type(url_info["url"]))
            self.start_urls.append(url_info)
        # 存一个最后爬取视频的时间，搜索视频超过1000个的时候，修改这个值，再次进行搜索
        self.last_time = self.end_time

    def start_requests(self):
        logging.info(self.start_urls)
        for url_info in self.start_urls:
            req = scrapy.Request(url=url_info["url"],
                                 callback=self.parse,
                                 meta={'url_info': json.dumps(url_info), "req_index": BilibiliSpider.req_index
                                       },
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
        url_info = json.loads(response.meta["url_info"])
        url_type = url_info["scrapy_type"]
        logging.info(f"url_type : {url_type}")
        # 视频
        if url_type == "video":
            item_lists = response.xpath(Page.video_list)
            video_html_text = response.text
            # 正则提取页面的js函数
            page_video_data = re.findall(r'[window.](__pinia\s*=\s*\(function\([^)]*\)[^)]*\)[^<]*)', video_html_text)
            if page_video_data:
                # 使用execjs解析函数，得到完整的json数据
                clean_string = page_video_data[0].encode('utf-8', 'ignore').decode('utf-8')
                clean_string = re.sub(r'[^\x00-\x7F]+', '', clean_string)
                js_compile = execjs.compile(clean_string)
                # 转换成字典格式
                video_json = js_compile.eval("__pinia")

                page = video_json["searchTypeResponse"]["searchTypeResponse"]["page"]  # 当前第几页
                pagesize = video_json["searchTypeResponse"]["searchTypeResponse"]["pagesize"]  # 每一页多少数据
                numPages = video_json["searchTypeResponse"]["searchTypeResponse"]["numPages"]  # 总共多少页
                numResults = video_json["searchTypeResponse"]["searchTypeResponse"]["numResults"]  # 总共搜索到多少视频
                # 视频列表
                item_list = video_json["searchTypeResponse"]["searchTypeResponse"]["result"]
                for item in item_list:
                    logging.info(f"video_json: {item}")
                    video_item = NeonScrapyItem()
                    # 这里获取的不一定准
                    # video_item['title'] = item["title"].replace("<em class=\"keyword\">", "").replace("</em>",
                    #                                                                                   "")  # 视频标题
                    video_item['record_ur'] = "https://www.bilibili.com/video/" + item["bvid"] + "/"  # 视频链接
                    logging.warning(f"req_video_url {video_item['record_ur']}")
                    # 当前排序
                    rank_index = item["rank_index"]
                    if rank_index == numResults:
                        # 更新最后一个视频的时间，后面如果要继续遍历，取这个时间戳
                        self.last_time = item["pubdate"] - 1
                    req = scrapy.Request(url=video_item['record_ur'], callback=self.get_video_details,
                                         meta={'video_item': video_item, "rank_index": rank_index,
                                               "req_index": BilibiliSpider.req_index},
                                         # req_config=self.req_config,
                                         dont_filter=True)
                    BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                    BilibiliSpider.req_index += 1
                    yield req
                # 如果当前不是最后一页，则翻页去拿下一页
                if page < numPages:
                    logging.info(f"now_page:{page},max_page:{numPages}, 继续下一页")
                    url_info["url"] = url_config["video"]["init_page"].format(keyword=self.key_word,
                                                                              page=page + 1, num=pagesize * page,
                                                                              begin_time=self.start_time,
                                                                              end_time=self.end_time) + "&order=pubdate"

                    req = scrapy.Request(url=url_info["url"],
                                         callback=self.parse,
                                         meta={'url_info': json.dumps(url_info), "req_index": BilibiliSpider.req_index})
                    BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                    BilibiliSpider.req_index += 1
                    yield req
                # 如果视频超过1000
                elif page == numPages and numResults == 1000:
                    logging.info(f"搜索视频超过1000条，修改时间戳范围，继续搜索，last_time:{self.last_time}")
                    url_info["url"] = url_config["video"]["init_page"].format(keyword=self.key_word,
                                                                              page=1, num=0,
                                                                              begin_time=self.start_time,
                                                                              end_time=self.last_time) + "&order=pubdate"

                    req = scrapy.Request(url=url_info["url"],
                                         callback=self.parse,
                                         meta={'url_info': json.dumps(url_info), "req_index": BilibiliSpider.req_index})
                    BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                    BilibiliSpider.req_index += 1
                    yield req
            else:
                logging.error(f"视频主界面，未成功提取到数据，url:{url_info['url']}")

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
                                           'url_info': json.dumps(url_info), "req_index": BilibiliSpider.req_index},
                                     # req_config=self.req_config,
                                     dont_filter=True)
                BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                BilibiliSpider.req_index += 1
                yield req
            else:
                logging.info("article_list is None")
        # 动态的
        elif url_type == "dynamic":
            config = url_info["config"]
            url_info["url"] = url_config["dynamic"]["init_page"].format(offset="", host_mid=config['UID'])
            headers = {"referer": None}
            logging.info(self.cookies)
            # 这里不能走随机请求头，不然会判定失败（大部分随机请求头对这个接口来说有点老，但是其他接口没事）
            req = scrapy.Request(url=url_info["url"],
                                 callback=self.get_dynamic_init_page,
                                 meta={'url_info': json.dumps(url_info), "randomProxy": False,
                                       "req_index": BilibiliSpider.req_index, "update_cookies": True},
                                 cookies=self.cookies,
                                 dont_filter=True,
                                 # headers=headers
                                 )
            BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            BilibiliSpider.req_index += 1
            yield req
        elif url_type == "biliGame":
            config = url_info["config"]
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
                                 meta={"biliGame_item": biliGame_item, "url_info": json.dumps(url_info),
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
        # item_list = response.meta["item_list"]
        # item_index = response.meta["item_index"]
        # url_info = json.loads(response.meta["url_info"])
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

    # 处理专栏详情界面
    def get_article_details(self, response):
        article_item = response.meta["article_item"]
        item_list = response.meta["item_list"]
        item_index = response.meta["item_index"]
        url_info = json.loads(response.meta["url_info"])
        # 数据类型
        article_item["data_type"] = "专栏"
        # 专栏的所有信息字符串
        article_html_info = response.xpath(Page.article_html_info).extract_first()
        article_html_json = re.findall(r"window.__INITIAL_STATE__=(.*);\(function\(\)", article_html_info)
        # todo 这里有概率重定向，但是又不一定会重定向，充满了玄学,所以用2套逻辑，加个保护
        article_html_json = json.loads(article_html_json[0])
        if article_html_json:
            if "readInfo" not in article_html_json and "detail" in article_html_json:
                for data in article_html_json["detail"]["modules"]:
                    if "module_author" in data:
                        if "pub_ts" in data["module_author"]:
                            article_item["msg_time"] = data["module_author"]["pub_ts"]
                            break
            else:
                # 专栏发布时间
                article_item["msg_time"] = article_html_json["readInfo"]["publish_time"]
            # 这里要单独排除一下置顶的
            if self.start_time > int(article_item["msg_time"]):
                logging.info(
                    f"发布时间：{article_item['msg_time']} out of range start_time:{self.start_time},end_time:{self.end_time}")
                return

            # 发布时间满足筛选需求，就继续去遍历下一个专栏
            if len(item_list) > item_index:
                logging.info("next article")
                next_video_item = item_list[item_index]
                logging.info(f"next video url:{next_video_item['record_ur']}")
                req = scrapy.Request(url=next_video_item['record_ur'], callback=self.get_article_details,
                                     meta={'article_item': next_video_item, "item_list": item_list,
                                           'url_info': json.dumps(url_info),
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
                                     meta={'url_info': json.dumps(url_info), "req_index": BilibiliSpider.req_index},
                                     # req_config=self.req_config
                                     )
                BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                BilibiliSpider.req_index += 1
                yield req
            if self.end_time < int(article_item["msg_time"]):
                logging.info(
                    f"发布时间：{article_item['msg_time']} >end_time,continue,start_time:{self.start_time},end_time:{self.end_time}")
                return
            if "readInfo" not in article_html_json and "detail" in article_html_json:
                logging.info(f"redirection req, new req: {response.url}")
                modules_list = article_html_json["detail"]["modules"]
                # 专栏标题
                article_item["data_type"] = self.get_dict_key(modules_list, "module_title")["text"]
                # 专栏发布人
                article_item["author"] = self.get_dict_key(modules_list, "module_author")["name"]
                # 专栏浏览量
                # article_item["read_count"] = article_html_json["readInfo"]["stats"]["view"]
                # 专栏点赞量
                article_item["like_count"] = self.get_dict_key(modules_list, "module_stat")["like"]["count"]
                # 专栏评论量
                article_item["comments_count"] = self.get_dict_key(modules_list, "module_stat")["comment"]["count"]
                # 专栏收藏量
                article_item["mark_count"] = self.get_dict_key(modules_list, "module_stat")["favorite"]["count"]
                # 专栏投币量
                article_item["coin_count"] = self.get_dict_key(modules_list, "module_stat")["coin"]["count"]
                # 专栏转发人数
                article_item["share_count"] = self.get_dict_key(modules_list, "module_stat")["forward"]["count"]
                # 专栏互动量（三连+转发+评论）
                article_item["active_count"] = 0
                self.get_active_count(article_item)
                # 专栏标签
                # if "tags" in article_html_json["readInfo"]:
                #     tag_list = article_html_json["readInfo"]["tags"]
                #     article_item["tag"] = [item["name"] for item in tag_list]
                # 专栏up主用户id
                article_item["user_id"] = self.get_dict_key(modules_list, "module_author")["mid"]
                yield self.send_user_card(article_item)
            else:
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
                yield self.send_user_card(article_item)
            # now_time = int(time.time())
            # user_id = str(article_item['user_id'])
            # if user_id not in self.bilibili_user_dicts or eval(self.bilibili_user_dicts[user_id])[
            #     "save_time"] < now_time - 86400 * 30:
            #     url = f"https://api.bilibili.com/x/web-interface/card?mid={article_item['user_id']}&photo=true&web_location=333.788"
            #     req = scrapy.Request(url=url, callback=self.get_user_card,
            #                          meta={'item': article_item, "req_index": BilibiliSpider.req_index},
            #                          dont_filter=True)
            #     BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            #     BilibiliSpider.req_index += 1
            #     yield req
            # else:
            #     yield self.get_redis_userinfo(article_item)
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
        url_info = json.loads(response.meta["url_info"])
        config = url_info["config"]
        resp_json = json.loads(response.body)
        if resp_json["code"] != 0:
            logging.info(resp_json)
            logging.info("get dynamic comment error")
            return
        # 动态的数据，在主界面就能全拿完，拿完直接去拿评论
        for dynamic_info in resp_json["data"]["items"]:
            dynamic_item = self.get_dynamic_details(dynamic_info, url_info["UID"])
            # 还有个置顶规则，恶心
            istop = False
            if "module_tag" in dynamic_info["modules"] and "text" in dynamic_info["modules"]["module_tag"]:
                if dynamic_info["modules"]["module_tag"]["text"] == "置顶":
                    istop = True
            # 如果不满足条件，直接就结束循环
            # if not self.check_time(int(dynamic_item["msg_time"])):
            if self.end_time < int(dynamic_item["msg_time"]):
                logging.info(
                    f"发布时间：{dynamic_item['msg_time']} >end_time,continue,start_time:{self.start_time},end_time:{self.end_time}")
                continue
            # 这里要单独排除一下置顶的
            elif self.start_time > int(dynamic_item["msg_time"]):
                if istop:
                    continue
                logging.info(
                    f"发布时间：{dynamic_item['msg_time']} out of range start_time:{self.start_time},end_time:{self.end_time}")
                return
            yield self.send_user_card(dynamic_item)
            # yield dynamic_item
            # now_time = int(time.time())
            # user_id = str(dynamic_item['user_id'])
            # if user_id not in self.bilibili_user_dicts or eval(self.bilibili_user_dicts[user_id])[
            #             "save_time"] < now_time - 86400 * 30:
            #     url = f"https://api.bilibili.com/x/web-interface/card?mid={dynamic_item['user_id']}&photo=true&web_location=333.788"
            #     req = scrapy.Request(url=url, callback=self.get_user_card,
            #                          meta={'item': dynamic_item, "req_index": BilibiliSpider.req_index},
            #                          dont_filter=True)
            #     BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            #     BilibiliSpider.req_index += 1
            #     yield req
            # else:
            #     yield self.get_redis_userinfo(dynamic_item)
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
                                 meta={'url_info': json.dumps(url_info), "randomProxy": False,
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

        if dynamic_info["modules"]["module_dynamic"]["desc"]:
            dynamic_item["content"] = dynamic_info["modules"]["module_dynamic"]["desc"]["text"]
            dynamic_item["title"] = ""
        elif dynamic_info["modules"]["module_dynamic"]["major"]:
            if "archive" in dynamic_info["modules"]["module_dynamic"]["major"]:
                dynamic_item["title"] = dynamic_info["modules"]["module_dynamic"]["major"]["archive"]["title"]
                dynamic_item["content"] = dynamic_info["modules"]["module_dynamic"]["major"]["archive"]["desc"]
            elif "article" in dynamic_info["modules"]["module_dynamic"]["major"]:
                dynamic_item["title"] = dynamic_info["modules"]["module_dynamic"]["major"]["article"]["title"]
                dynamic_item["content"] = dynamic_info["modules"]["module_dynamic"]["major"]["article"]["desc"]
            elif "opus" in dynamic_info["modules"]["module_dynamic"]["major"]:
                print( dynamic_info["modules"]["module_dynamic"]["major"]["opus"])
                dynamic_item["title"] = dynamic_info["modules"]["module_dynamic"]["major"]["opus"]["title"]
                dynamic_item["content"] = dynamic_info["modules"]["module_dynamic"]["major"]["opus"]["summary"]["desc"]
            else:
                dynamic_item["title"] = ""
                dynamic_item["content"] = ""
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
        dynamic_item["active_count"] = 0
        self.get_active_count(dynamic_item)
        # 专栏up主用户id
        dynamic_item["user_id"] = uid
        return dynamic_item

    # 获取游戏中心评分，评论数
    def get_biligame_summer(self, response):
        url_info = json.loads(response.meta["url_info"])
        resp_json = json.loads(response.body)
        if resp_json["code"] != 0:
            logging.info("get biligame_summer error")
            return
        biliGame_item = response.meta["biliGame_item"]
        # 游戏评分
        biliGame_item["mark"] = resp_json["data"]["grade"]
        # 游戏评论数
        biliGame_item["comments_count"] = resp_json["data"]["comment_number"]
        url = url_config["biliGame"]["game_info"].format(id=url_info["config"]["gameId"])
        req = scrapy.Request(url=url, callback=self.get_biligame_gameinfo,
                             meta={"biliGame_item": biliGame_item, "url_info": json.dumps(url_info),
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
        url_info = json.loads(response.meta["url_info"])
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
                             meta={"url_info": json.dumps(url_info),
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
        url_info = json.loads(response.meta["url_info"])
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
            yield self.send_user_card(comment_item)
            # now_time = int(time.time())
            # user_id = str(comment_item['user_id'])
            # if user_id not in self.bilibili_user_dicts or eval(self.bilibili_user_dicts[user_id])[
            #             "save_time"] < now_time - 86400 * 30:
            #     url = f"https://api.bilibili.com/x/web-interface/card?mid={comment_item['user_id']}&photo=true&web_location=333.788"
            #     req = scrapy.Request(url=url, callback=self.get_user_card,
            #                          meta={'item': comment_item, "req_index": BilibiliSpider.req_index},
            #                          dont_filter=True)
            #     BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
            #     BilibiliSpider.req_index += 1
            #     yield req
            # else:
            #     yield self.get_redis_userinfo(comment_item)
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
                                     meta={"url_info": json.dumps(url_info),
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
                                 meta={"url_info": json.dumps(url_info),
                                       "page_index": page_index, "comment_count": comment_count - 10, "oid": oid,
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
                # yield self.get_biligame_single_reply(sub_reply, reply_type="子评论", oid=response.meta["oid"])
                comment_item = self.get_biligame_single_reply(sub_reply, reply_type="子评论", oid=response.meta["oid"])
                yield self.send_user_card(comment_item)
                # now_time = int(time.time())
                # user_id = str(comment_item['user_id'])
                # if user_id not in self.bilibili_user_dicts or eval(self.bilibili_user_dicts[user_id])[
                #             "save_time"] < now_time - 86400 * 30:
                #     url = f"https://api.bilibili.com/x/web-interface/card?mid={comment_item['user_id']}&photo=true&web_location=333.788"
                #     req = scrapy.Request(url=url, callback=self.get_user_card,
                #                          meta={'item': comment_item, "req_index": BilibiliSpider.req_index},
                #                          dont_filter=True)
                #     BilibiliSpider.not_req_list[BilibiliSpider.req_index] = req
                #     BilibiliSpider.req_index += 1
                #     print(222222222222222222222222222222)
                #     print(comment_item['user_id'])
                #     print(self.bilibili_user_dicts)
                #     yield req
                # else:
                #     yield self.get_redis_userinfo(comment_item)

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
