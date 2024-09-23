import random

from yihai_scrapy import config
import requests
import json
import time


class IpProxy:
    # 账号密码
    user_password = "d2501514560:fd9fjsz8"
    # 订单id
    secret_id = "ofcljov0wrq9oj5tyu28"
    # token/请求签名
    secret_token = ""
    # token 过期时间
    expire = 0
    # proxy列表
    proxy_list = {}
    # 随机ip个数
    ip_count = 1

    # 获取签名
    @staticmethod
    def get_signature():
        url = "https://auth.kdlapi.com/api/get_secret_token"
        headers = {"Content-Type": "application/x-www-form-urlencoded"}
        data = {
            "secret_id": 'ofcljov0wrq9oj5tyu28',
            "secret_key": "y0z5vxgbakbqc0lxl8vrlld9eumhxyw1"
        }
        result = requests.post(url=url, headers=headers, data=data)
        if result.status_code != 200:
            print(f"get_secret_token Response status_code != 200, status_code:{result.status_code}")
            return
        json_data = result.json()
        if json_data["code"] != 0:
            print(f"get_secret_token code != 0, Response res_code:{json_data['code']}")
            return
        print(f"get_secret_token success, data: {json_data}")
        # 使用secret_token直接当签名
        IpProxy.secret_token = json_data["data"]["secret_token"]
        not_time = int(time.time())
        IpProxy.expire = json_data["data"]["expire"] + not_time

    # 调用api拉取ip
    @staticmethod
    def get_dps(num):
        # 如果签名过期时间小于五分钟，重新去拉取，更新一下签名
        now_time = int(time.time())
        if IpProxy.expire - now_time < 300:
            IpProxy.get_signature()
        url = f"https://dps.kdlapi.com/api/getdps?secret_id={IpProxy.secret_id}&num={num}&signature={IpProxy.secret_token}&format=json"
        result = requests.get(url=url)
        if result.status_code != 200:
            print(f"getdps Response status_code != 200, status_code:{result.status_code}")
            return
        json_data = result.json()
        if json_data["code"] != 0:
            print(f"getdps Response code != 0, res_code:{json_data['code']}")
            return
        print(f"get new_ip success, new_ip: {json_data}")
        for proxy in json_data["data"]["proxy_list"]:
            IpProxy.proxy_list[proxy] = 0
        # IpProxy.proxy_list.extend(json_data["data"]["proxy_list"])

    # 检测代理剩余有效时间
    @staticmethod
    def get_dps_valid_time(proxy):
        # 如果签名过期时间小于五分钟，重新去拉取，更新一下签名
        now_time = int(time.time())
        if IpProxy.expire -now_time < 300:
            IpProxy.get_signature()
        # 如果等于0，代表没获取过时间，获取一下
        if IpProxy.proxy_list[proxy] == 0:
            url = f"https://dps.kdlapi.com/api/getdpsvalidtime?secret_id={IpProxy.secret_id}&signature={IpProxy.secret_token}&proxy={proxy}"
            result = requests.get(url=url)
            if result.status_code != 200:
                print(f"getdpsvalidtime Response status_code != 200, status_code:{result.status_code}")
                return -1
            json_data = result.json()
            if json_data["code"] != 0:
                print(f"getdpsvalidtime Response code != 0, res_code:{json_data['code']}")
                return -1
            print(json_data["data"])
            IpProxy.proxy_list[proxy] = (now_time + json_data["data"][proxy])
            print(f"{proxy}:{IpProxy.proxy_list[proxy]},now_time:{now_time},111")
            return json_data["data"][proxy]
        else:
            print(f"{proxy}:{IpProxy.proxy_list[proxy]},now_time:{now_time},222")
            return IpProxy.proxy_list[proxy] - now_time

    # 检测代理有效性
    @staticmethod
    def check_dps_valid(proxy):
        # 如果签名过期时间小于五分钟，重新去拉取，更新一下签名
        now_time = int(time.time())
        if IpProxy.expire - now_time < 300:
            IpProxy.get_signature()
        # 如果等于0，代表没获取过时间，获取一下
        url = f"https://dps.kdlapi.com/api/checkdpsvalid?secret_id={IpProxy.secret_id}&signature={IpProxy.secret_token}&proxy={proxy}"
        result = requests.get(url=url)
        if result.status_code != 200:
            print(f"checkdpsvalid Response status_code != 200, status_code:{result.status_code}")
            return False
        json_data = result.json()
        if json_data["code"] != 0:
            print(f"checkdpsvalid Response code != 0, res_code:{json_data['code']}")
            return False
        print(json_data["data"])
        # IpProxy.proxy_list[proxy] = now_time + json_data["data"][proxy]
        return json_data["data"][proxy]

    # 获取订单ip剩余余额
    def get_ip_balance(self):
        now_time = int(time.time())
        if IpProxy.expire -now_time < 300:
            IpProxy.get_signature()
        # 暂时不需要，先预留
        url = f"https://dps.kdlapi.com/api/getipbalance?secret_id={IpProxy.secret_id}&signature={IpProxy.secret_token}"
        result = requests.get(url=url)
        if result.status_code != 200:
            print(f"getipbalance Response status_code != 200, status_code:{result.status_code}")
            return -1
        json_data = result.json()
        if json_data["code"] != 0:
            print(f"getipbalance Response code != 0, res_code:{json_data['code']}")
            return -1
        return json_data["data"]["balance"]

    # 获取ip
    @staticmethod
    def get_proxy():
        while True:
            # 1、从列表里去拿,如果列表数量小于随机ip数，则重新添加几个随机ip
            if len(IpProxy.proxy_list) < IpProxy.ip_count:
                IpProxy.get_dps(IpProxy.ip_count-len(IpProxy.proxy_list))
            # 随机拿一个
            proxy = random.choice(list(IpProxy.proxy_list.keys()))
            # 2、判断这个ip剩余时间，是否大于30s,小于30s就换一个新的
            ip_expire = IpProxy.get_dps_valid_time(proxy)
            print(f"proxy:{proxy} ip_expire:{ip_expire}")
            if not IpProxy.check_dps_valid(proxy):
                print(f"proxy:{proxy}不可用")
                IpProxy.proxy_list.pop(proxy)
            elif ip_expire < 0:
                print(f"get {proxy} valid time error")
                return proxy
            elif ip_expire <= 30:
                IpProxy.proxy_list.pop(proxy)
            else:
                print(f"proxy: {proxy}")
                break
        return proxy

    @staticmethod
    def del_proxy(proxy):
        proxy = proxy.split("http://")[-1]
        if proxy in IpProxy.proxy_list:
            IpProxy.proxy_list.pop(proxy)
        else:
            print(f"{proxy} not in proxy_list")


if __name__ == '__main__':
    data = IpProxy.get_proxy()
    print(data)
    # data = IpProxy.get_dps_valid_time("117.82.189.111:18112")
    # print(data)
