from selenium import webdriver
import redis
from yihai_scrapy.config import redis_config
from yihai_scrapy.config import req_config
import json
import logging


# cookies有2种,selenium的存储，以及req_config的存储
class ScrapyCookies:
    def __init__(self,run_type):
        """
        @param run_type: bilibili/TapTap
        """
        self.rds = redis.StrictRedis(host=redis_config["host"], port=redis_config["port"], db=redis_config["db"],
                                     decode_responses=redis_config["decode_responses"])
        self.key = run_type + ":cookies"

    # 获取最新的cookies
    def get_redis_cookies(self):
        # 如果不存在这个key,更新一下redis的key
        if not self.rds.exists(self.key):
            self.init_redis_cookies(req_config["cookies"])
        all_cookie = self.rds.lrange(self.key, 0, -1)
        return all_cookie

    # 设置redis的cookies(selenium传过来的)
    def set_redis_cookies(self, cookies):
        if self.rds.exists(self.key):
            self.rds.delete(self.key)
        for cookie in cookies:
            json_data = json.dumps(cookie)
            self.rds.lpush(self.key, json_data)
        all_cookie = self.get_redis_cookies()
        return all_cookie

    # 初始化一下cookies
    def init_redis_cookies(self, cookies):
        if self.rds.exists(self.key):
            self.rds.delete(self.key)
        value = ""
        for data in cookies.split('; '):
            if data.split('=')[0] == "SESSDATA":
                value = data.split('=')[1]
        dicts = {'domain': '.bilibili.com', 'expiry': 1746526863, 'httpOnly': True, 'name': 'SESSDATA', 'path': '/',
         'sameSite': 'Lax', 'secure': True,
         'value': value}
        json_data = json.dumps(dicts)
        self.rds.lpush(self.key, json_data)

    # 更新config配置里的cookies
    def update_config_cookies(self):
        cookies = self.get_redis_cookies()
        config_cookies = "; ".join([f"{json.loads(cookie)['name']}={json.loads(cookie)['value']}" for cookie in cookies])
        req_config["cookies"] = config_cookies
        logging.info(f"req_config['cookies']: {req_config['cookies']}")

    def get_bilibili_cookies(self):
        driver = webdriver.Chrome()
        driver.get('http://www.bilibili.com')

        # 获取redis里的cookies
        cookies = self.get_redis_cookies()

        # 把cookies添加到
        for cookie in cookies:
            driver.add_cookie(json.loads(cookie))

        # 重新访问网站
        driver.get('http://www.bilibili.com')
        # 获取网页最新的cookies
        cookies = driver.get_cookies()
        for cookie in cookies:
            logging.info(cookie["name"] + ": " + cookie["value"])
        # 更新redis的cookies
        cookies = self.set_redis_cookies(cookies)
        logging.info(f"set_redis_cookies: {cookies}")


if __name__ == '__main__':
    # "NRMGNLWHR6bllYa2k0Y1lBIIEC"
    # 创建浏览器对象
    data = ScrapyCookies("bilibili")
    # data.init_redis_cookies(req_config["cookies"])
    data.get_bilibili_cookies()
    # driver.get('http://www.bilibili.com')
    #
    # # 获取redis里的cookies
    # Cookies = ScrapyCookies("bilibili")
    # Cookies.init_redis_cookies(req_config["cookies"])
    # cookies = Cookies.get_redis_cookies()
    #
    # # 把cookies添加到
    # for cookie in cookies:
    #     driver.add_cookie(json.loads(cookie))
    #
    # # 重新访问网站
    # driver.get('http://www.bilibili.com')
    # # 获取网页最新的cookies
    # cookies = driver.get_cookies()
    # for cookie in cookies:
    #     print(cookie["name"] +": "+cookie["value"])
    # # 更新redis的cookies
    # cookies = Cookies.set_redis_cookies(cookies)
    # print(cookies)
    # input(1111)
    # for cookie in cookie_list:
    #     dicts = json.loads(cookie)
    #     print(dicts)
    #     print(type(dicts))