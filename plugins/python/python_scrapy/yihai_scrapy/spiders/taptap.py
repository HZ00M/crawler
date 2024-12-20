import json
import logging
import re
import time
from distutils.command.config import config

from selenium.webdriver.common.devtools.v85.network import Response

# 解决execjs执行js时产生的乱码报错，需要在导入execjs模块之前，让popen的encoding参数锁定为utf-8
from yihai_scrapy import Util
import subprocess
from functools import partial
subprocess.Popen = partial(subprocess.Popen, encoding="utf-8")
import execjs
import os

import scrapy
from yihai_scrapy.items import TapTapScrapyItem


class TapTapSpider(scrapy.Spider):
    name = "TapTap"
    allowed_domains = ["taptap.cn"]
    start_urls = ["https://www.taptap.cn/webapiv2/review/v2/list-by-app?"]
    req_index =0
    not_req_list = {}
    custom_settings = {
        'ITEM_PIPELINES': {
            "yihai_scrapy.pipelines.NeonScrapyPipeline": 300,
            "yihai_scrapy.pipelines.feishuPipeline": 301,
        },
    }

    def __init__(self, key_word="", execute_id=0, execute_name="", ignore_word="", begin_time=0, end_time=0, model=0,game_id=204894,
                 *args,
                 **kwargs):
        logging.info(kwargs)
        super(TapTapSpider, self).__init__(*args, **kwargs)
        self.HEADERS = {'Host': 'www.taptap.cn',
                   'Connection': 'Keep-Alive',
                   'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.97 Safari/537.36 Core/1.116.460.400 QQBrowser/13.3.6166.400',
                   }
        self.start_time = begin_time
        self.end_time = end_time
        # 抓取的时间范围
        if model == 0:
            self.radius = 3600
        self.game_id = game_id
        # jenkins传过来的参数
        if "game_id" in os.environ:
            self.game_id = os.environ["game_id"]
        self.key_word = key_word
        # self.game_id = 204894


    def start_requests(self):
        logging.info("start_requests")
        reply_url = self.get_reply_url(self.game_id,0)
        req = scrapy.Request(url=reply_url,
                             callback=self.parse,
                             headers=self.HEADERS,
                             method="GET",
                             meta={"req_index": TapTapSpider.req_index,
                                   "index":0,},
                             dont_filter=True
                             )
        TapTapSpider.not_req_list[TapTapSpider.req_index] = req
        TapTapSpider.req_index += 1
        yield req

    # 总入口
    def parse(self, response):
        result = json.loads(response.body)
        if not result["success"]:
            logging.error("请求失败咯，检查参数咯")
        for item in result["data"]["list"]:
            review_item = TapTapScrapyItem()
            review_item["user_id"] = item["moment"]["author"]["user"]["id"]
            review_item["author"] = item["moment"]["author"]["user"]["name"]
            review_item["review_id"] = item["moment"]["review"]["id"]
            review_item["review_url"] = "https://www.taptap.cn/review/" + str(review_item["review_id"])
            review_item["score"] = item["moment"]["review"]["score"]
            review_item["updated_time"] = item["moment"]["commented_time"]
            if "devices" in item["moment"]:
                review_item["device"] = item["moment"]["device"]
            review_item["contents"] = item["moment"]["review"]["contents"]["text"]
            # 推荐和不推荐
            review_item["recommend"] = []
            review_item["not_recommend"] = []
            if "ratings" in item["moment"]["review"]:
                for data in item["moment"]["review"]["ratings"]:
                    if data["value"] == "up":
                        review_item["recommend"].append(data["label"])
                    elif data["value"] == "down":
                        review_item["not_recommend"].append(data["label"])
            # 游戏时间
            if "played_spent" in item["moment"]["review"]:
                review_item["played_spent"] = item["moment"]["review"]["played_spent"]
            if review_item["updated_time"] + 86400 < int(time.time()):
                logging.info("当前发布时间，大于1小时了，跳过")
                return
            else:
                yield review_item
        index = response.meta["index"] + 10
        reply_url = self.get_reply_url(self.game_id, index)
        req = scrapy.Request(url=reply_url,
                             callback=self.parse,
                             headers=self.HEADERS,
                             method="GET",
                             meta={"req_index": TapTapSpider.req_index,
                                   "index": index, },
                             dont_filter=True
                             )
        TapTapSpider.not_req_list[TapTapSpider.req_index] = req
        TapTapSpider.req_index += 1
        yield req



    def get_reply_url(self,game_id, start_index):
        prams = {
            "app_id": game_id,
            "from": start_index,
            "sort": "new",
            "stage_type": 2,
            "X-UA": "V=1&PN=WebApp&LANG=zh_CN&VN_CODE=102&LOC=CN&PLT=PC&DS=Android&UID=bce4f5ec-8c12-46c1-8f46-cd1d83271abd&OS=Windows&OSV=10&DT=PC",
        }
        url = "https://www.taptap.cn/webapiv2/review/v2/list-by-app?"
        for data in prams:
            if data == "X-UA":
                url_data = Util.pagination_str_req(prams["X-UA"])
                url += f"{data}={url_data}"
            else:
                url += f"{data}={prams[data]}&"
        return url