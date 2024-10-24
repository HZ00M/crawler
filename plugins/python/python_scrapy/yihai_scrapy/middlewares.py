# Define here the models for your spider middleware
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/spider-middleware.html
import scrapy
from requests import Request
from scrapy import signals
from yihai_scrapy.settings import USER_AGENT_List
# from yihai_scrapy.settings import PROXY_LIST
from yihai_scrapy.ip_proxy import IpProxy
from scrapy.exceptions import IgnoreRequest
from twisted.internet import reactor
import logging
from yihai_scrapy import logger
import random
import base64
import time

# useful for handling different item types with a single interface
from itemadapter import is_item, ItemAdapter


class NeonScrapySpiderMiddleware:
    # Not all methods need to be defined. If a method is not defined,
    # scrapy acts as if the spider middleware does not modify the
    # passed objects.

    @classmethod
    def from_crawler(cls, crawler):
        # This method is used by Scrapy to create your spiders.
        s = cls()
        crawler.signals.connect(s.spider_opened, signal=signals.spider_opened)
        return s

    def process_spider_input(self, response, spider):
        # Called for each response that goes through the spider
        # middleware and into the spider.

        # Should return None or raise an exception.
        return None

    def process_spider_output(self, response, result, spider):
        # Called with the results returned from the Spider, after
        # it has processed the response.

        # Must return an iterable of Request, or item objects.
        for i in result:
            yield i

    def process_spider_exception(self, response, exception, spider):
        # Called when a spider or process_spider_input() method
        # (from other spider middleware) raises an exception.

        # Should return either None or an iterable of Request or item objects.
        pass

    def process_start_requests(self, start_requests, spider):
        # Called with the start requests of the spider, and works
        # similarly to the process_spider_output() method, except
        # that it doesn’t have a response associated.

        # Must return only requests (not items).
        for r in start_requests:
            yield r

    def spider_opened(self, spider):
        spider.logger.info("Spider opened: %s" % spider.name)


class NeonScrapyDownloaderMiddleware:
    # Not all methods need to be defined. If a method is not defined,
    # scrapy acts as if the downloader middleware does not modify the
    # passed objects.

    @classmethod
    def from_crawler(cls, crawler):
        # This method is used by Scrapy to create your spiders.
        s = cls()
        crawler.signals.connect(s.spider_opened, signal=signals.spider_opened)
        return s

    def process_request(self, request, spider):
        # Called for each request that goes through the downloader
        # middleware.

        # Must either:
        # - return None: continue processing this request
        # - or return a Response object
        # - or return a Request object
        # - or raise IgnoreRequest: process_exception() methods of
        #   installed downloader middleware will be called
        ua = random.choice(USER_AGENT_List)
        request.headers["User-Agent"] = ua

    def process_response(self, request, response, spider):
        # Called with the response returned from the downloader.

        # Must either;
        # - return a Response object
        # - return a Request object
        # - or raise IgnoreRequest
        return response

    def process_exception(self, request, exception, spider):
        # Called when a download handler or a process_request()
        # (from other downloader middleware) raises an exception.

        # Must either:
        # - return None: continue processing this exception
        # - return a Response object: stops process_exception() chain
        # - return a Request object: stops process_exception() chain
        pass

    def spider_opened(self, spider):
        spider.logger.info("Spider opened: %s" % spider.name)


class RandomProxy:
    def __init__(self, max_retry_times=3):
        self.max_retry_times = max_retry_times

    # todo 现在这里是自己的ip写的，能跑就行，到时候换正式的随机ip，还要再改
    def process_request(self, request, spider):
        if "rerun" in request.meta:
            logging.info("重发中，重发中")
        # 不分请求不需要随机ip(主要需要随机的是高频次调用的，如访问用户名片)
        if "randomProxy" in request.meta:
            if not request.meta["randomProxy"]:
                logging.info("不需要随机")
                return
        # 随机请求头
        ua = random.choice(USER_AGENT_List)
        request.headers["User-Agent"] = ua
        # 获取一个随机ip
        proxy = IpProxy.get_proxy()
        # 对代理进行加密认证
        b64_up = base64.b64encode(IpProxy.user_password.encode())
        # 设置认证
        request.headers["Proxy-Authorization"] = 'Basic ' + b64_up.decode()
        # 设置代理,如果传参的时候传了ip地址，就用传过来的，不然就走随机
        request.meta['proxy'] = 'http://' + proxy


    def process_response(self, request, response, spider):
        if response.status != 200:
            logging.info(f"Non-200 response {response.status} for URL: {response.url}")
            # 可以在这里进行额外的处理，例如重试请求
            retries = request.meta.get('retries', 0)
            proxy = request.meta.get('proxy', "")
            if retries < self.max_retry_times:
                # 增加重试次数
                retries += 1
                # 创建一个新的请求对象，并将重试次数传递到请求的 meta 属性中
                new_request = request.copy()
                IpProxy.del_proxy(proxy)
                new_request.meta['retries'] = retries
                logging.info(f"retries the {retries}, max:{self.max_retry_times}")
                # 返回新的请求对象进行重试
                return new_request
            else:
                # 如果超过最大重试次数，忽略请求
                raise IgnoreRequest("Max retries exceeded")
        return response



# 随机等待
class RandomDelayMiddleware:
    def __init__(self, delay_min=1, delay_max=5):
        self.delay_min = delay_min
        self.delay_max = delay_max

    @classmethod
    def from_crawler(cls, crawler):
        # 从Scrapy配置文件中读取最小和最大等待时间
        delay_min = crawler.settings.getint('RANDOM_DELAY_MIN')
        delay_max = crawler.settings.getint('RANDOM_DELAY_MAX')
        return cls(delay_min, delay_max)

    def process_request(self, request, spider):
        delay = random.randint(self.delay_min, self.delay_max)
        logging.info(f"Waiting for {delay} seconds...")
        # 使用Python标准库中的time模块进行等待
        time.sleep(delay)

# 定时结束
class TwistedMiddleware:
    """
    10s定时执行一次，如果120s没有消息过来，就自动停止运行
    """
    def __init__(self):
        self.start_time = time.time()
        self.spider = None
        self.index = 0
        reactor.callLater(5, self.myFunction)

    def myFunction(self):
        if time.time() - self.start_time > 120:
            logging.info("120s没有新消息，停止运行")
            self.spider.crawler.engine.close_spider(self.spider, 'timeout')
        elif time.time() - self.start_time > 30 and self.spider.not_req_list:
            logging.info("add new req")
            logging.info(len(self.spider.not_req_list))
            remove_list = []
            for req in self.spider.not_req_list:
                self.spider.not_req_list[req].dont_filter=True
                if "rerun" in self.spider.not_req_list[req].meta:
                    self.spider.not_req_list[req].meta["rerun"] += 1
                else:
                    self.spider.not_req_list[req].meta["rerun"] = 1
                if self.spider.not_req_list[req].meta["rerun"] > 3:
                    remove_list.append(req)
                    continue
                logging.info(f"new req {self.spider.not_req_list[req].url}")
                self.spider.crawler.engine.crawl(self.spider.not_req_list[req])
            # 删除重复请求超过3次的请求，防止死循环
            for req in remove_list:
                self.spider.not_req_list.pop(req)
        else:
            logging.info(f"上一次请求时间:{int(time.time() - self.start_time)}s前")
        # 再次安排这个函数的调用
        reactor.callLater(10, self.myFunction)

    def process_request(self, request, spider):
        self.start_time = time.time()
        self.spider = spider
        logging.info(f"req : {request.url}")
        logging.info(f"spider.index : {spider.req_index}")
        logging.info(f"request.meta: {request.meta}")
        if "req_index" in request.meta:
            try:
                logging.info(f"self.index: {self.index}")
                print(request.meta["req_index"])
                self.index += 1
                self.spider.not_req_list.pop(request.meta["req_index"])
            except:
                logging.info("取消发送请求")
                raise IgnoreRequest("请求已被取消")
        else:
            logging.info("正常情况，日志到不了这里，但是弱网情况，有小概率有bug，部分请求首次过来的时候，req_index参数丢了，但是其他参数又还在，重发参数又在了，就离谱")
            logging.info(request.url)
            raise IgnoreRequest("请求已被取消")


