# -*- coding: utf-8 -*-
# import execjs
#
# with open('commentDecryption.js','r',encoding='utf-8') as f:
#     jquary = f.read()
#     ctx = execjs.compile(jquary).call('md5$2',"2")
#     print(ctx)
#     f.close()
from pprint import pprint

import requests
import time

from requests.auth import HTTPBasicAuth

# from setuptools.package_index import user_agent

from yihai_scrapy import Util
from yihai_scrapy.ip_proxy import IpProxy

# from yihai_scrapy import items
# import redis
# import pymysql
# from pymysql import OperationalError, ProgrammingError

# oid = 1506472752
# pagination_str = Util.pagination_str({"offset": ""})
# wts = 1722415777
# temp = [
#     "mode=3",
#     f"oid={oid}",
#     f"pagination_str={pagination_str}",
#     "plat=1",
#     "seek_rpid=",
#     "type=1",
#     "web_location=1315875",
#     f"wts={wts}",
# ]
#
# replay = [
#     "appkey=h9Ejat5tFh81cq8V",
#     "comment_no=CM1781504152308944896",
#     "game_base_id=106852",
#     "page_num=1",
#     "page_size=10",
#     "request_id=zkGBQS9CrZyXNXdjlOIUBEn6OAbxSDBs",
#     "ts=1723727308771",
# ]
# # replay = [
# #     "appkey=h9Ejat5tFh81cq8V",
# #     "game_base_id=106852",
# #     "request_id=bBvhLiPN1pCvRnM5ZPzDURF8tyPTFMdd",
# #     "ts=1723690453516",
# # ]
#
# "sign=d1003bf258918e8b3c7a7d6e877694bd",
# "w_rid=e3a945fb7b77a868b4289fb308ae96fa",
# print("&".join(replay))
# print(
#     "appkey=h9Ejat5tFh81cq8V&game_base_id=106852&page_num=6&page_size=10&rank_type=3&request_id=Yd3ShQitATfCEfsxCJYdgO2Knn23B5jO&ts=1723687900378BdiI92bjmZ9QRcjJBWv2EEssyjekAGKt")
# print("game_base_id=106852&rank_type=2&page_num=1&page_size=10&ts=1723726908359&request_id=tevgTyt7sjCqzl4CKw849enLc0DpWr4u&appkey=h9Ejat5tFh81cq8V")
# w_rid = Util.biligame_comment_decryption("&".join(replay))
# print(w_rid)
# from yihai_scrapy.config import req_config
# # if __name__ == '__main__':
#
# url2 = "https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/space?offset=959804510703714360&host_mid=109710253"
# url = "https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/space?offset=&host_mid=109710253"
# headers = {
#     "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
# }
# # temp = "buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc"
# temp = req_config
# temp = {'header_theme_version': 'CLOSE', 'rpdid': "|(J|~uR|Jmkl0J'uYmku|YYRR", 'enable_web_push': 'DISABLE', 'buvid_fp_plain': 'undefined', 'buvid4': 'FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D', 'hit-dyn-v2': '1', 'LIVE_BUVID': 'AUTO3217084866844183', 'FEED_LIVE_VERSION': 'V8', 'is-2022-channel': '1', 'PVID': '1', 'CURRENT_QUALITY': '64', 'buvid3': 'F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc', 'b_nut': '1724036190', '_uuid': '1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc', 'DedeUserID': '320899158', 'DedeUserID__ckMd5': '91f0ee8638a6fe1a', 'bili_ticket': 'eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjU1MDA3OTIsImlhdCI6MTcyNTI0MTUzMiwicGx0IjotMX0.AZE8MU5RLKku6u_iasdPCARz5jLWVbD11zL6mUT5HkI', 'bili_ticket_expires': '1725500732', 'SESSDATA': '64ef28b1%2C1740793594%2Cc6caa%2A92CjCznTnzYgrUEEb7C_7UZgFBMmtsYPWGQOriJQdKll5fqX9IE-s8su5xiqYHFxWOLf8SVlN4VmFIY1BQU2xTWWpueTFuN2E0bzc5VW80ZkF4QmNoRlRCNkVSdG5wODBMTjVpOEQzcDJMVUZBb0NSVDRJczcwdTV5WmVlTUpQLThFYTl3RFdSQ2tBIIEC', 'bili_jct': '58f46a89b1426fbf784706a4ead12ec6', 'sid': '8teq1fn9', 'bp_t_offset_320899158': '972400442858274816', 'bmg_af_switch': '1', 'bmg_src_def_domain': 'i2.hdslb.com', 'fingerprint': '7bd1bd60afa71ea5dbb7df3f91889676', 'buvid_fp': '7bd1bd60afa71ea5dbb7df3f91889676', 'CURRENT_BLACKGAP': '0', 'CURRENT_FNVAL': '16', 'b_lsid': '77A3D10EC_191BBDE8458', 'home_feed_column': '4', 'browser_resolution': '763-956'}
# # temp = "header_theme_version=CLOSE; CURRENT_FNVAL=4048; rpdid=|(J|~uR|Jmkl0J'uYmku|YYRR; enable_web_push=DISABLE; buvid_fp_plain=undefined; buvid4=FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D; hit-dyn-v2=1; LIVE_BUVID=AUTO3217084866844183; FEED_LIVE_VERSION=V8; is-2022-channel=1; PVID=1; fingerprint=fb14b20ab08019acee6078daa7e2c91d; CURRENT_QUALITY=64; buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc; b_nut=1724920657; _uuid=1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc; bmg_af_switch=1; bmg_src_def_domain=i2.hdslb.com; bili_ticket=eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjQ5MTY1MjcsImlhdCI6MTcyNDY1NzI2NywicGx0IjotMX0.nY9E3EF-94RNARLdNPJWvTL5o-sd2AQW-AkRdYLWMGM; bili_ticket_expires=1734916467; b_lsid=8661FE9D_19197D08D86; bp_t_offset_320899158=970639922878742528; SESSDATA=c0a25122%2C1740385362%2C8f435%2A81CjBqvv1FXkXe9dxKAsPi5QIMcx-62BNCJZwhD5hY4D85VGR_BxRJjC4mLfUSJheGAHISVkxtUWFXQkZNZkNJYUFXMW5PekhSNnFCeUVYWHBEdmxtbUxQdnhHREwwYl9rTTVUV0gxUmE2MDdvMjcxUUVZaGdrS2U5blItdzYzSE9aN1FhRnBsZ3BRIIEC; bili_jct=b1841e60b8b183bd0b6d7fd285d06bde; DedeUserID=320899158; DedeUserID__ckMd5=91f0ee8638a6fe1a; buvid_fp=5e15f487d67c2bf2510d766483318b52; sid=6p42pf16; home_feed_column=4; browser_resolution=819-956"
# # temp1 = "header_theme_version=CLOSE; CURRENT_FNVAL=4048; rpdid=|(J|~uR|Jmkl0J'uYmku|YYRR; enable_web_push=DISABLE; buvid_fp_plain=undefined; buvid4=FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D; hit-dyn-v2=1; LIVE_BUVID=AUTO3217084866844183; FEED_LIVE_VERSION=V8; is-2022-channel=1; PVID=1; fingerprint=fb14b20ab08019acee6078daa7e2c91d; CURRENT_QUALITY=64; buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc; b_nut=1724036190; _uuid=1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc; bmg_af_switch=1; bmg_src_def_domain=i2.hdslb.com; DedeUserID=320899158; DedeUserID__ckMd5=91f0ee8638a6fe1a; bp_t_offset_320899158=970662913838678016; bili_ticket=eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjUxNzQyMjksImlhdCI6MTcyNDkxNDk2OSwicGx0IjotMX0.5SndKDTIpbrvYHvLvEp7sSLmrdMic-3mDMQ2M9MUT5g; bili_ticket_expires=1725174169; SESSDATA=8f856492%2C1740471230%2C2e6d4%2A82CjC4yIb9OKWUyAY7h0NDFn8_uMPR8XYaDkYcIkJZGxzXhEpt1fDIWI4d8tB8dOtrW4kSVmw1TDFPb1h0akwyY3Q0andnOUJ6aFpkTUVlSHpLbXlaM0w2R3R1WU8zWUJFSzdxakJ0TmU2ZUE0THhpdlRYMjVSbGhQZm9SWk5lT20ycDY3STh0cUFRIIEC; bili_jct=05530fa211da8eab9ff4dffb4f1ab4c8; sid=5cjx9kor; b_lsid=4810AB2B9_1919D4C0BC9; buvid_fp=fb14b20ab08019acee6078daa7e2c91d; home_feed_column=4; browser_resolution=762-956"
# # req_config = {data.split('=')[0]: data.split('=')[1] for data in temp.split('; ')}
# # cookies1 = {data.split('=')[0]: data.split('=')[1] for data in temp1.split('; ')}
# # print(req_config)
# data = requests.get(url=url, headers=headers, req_config=temp)
# data2 = requests.get(url=url2, headers=headers, req_config=req_config)
# print(data.text)
# print(data2.text)
# dicts = {}
# dicts1 = {}
# for key in req_config:
#     if key in cookies1:
#         if req_config[key] == cookies1[key]:
#             continue
#         else:
#             dicts[key] = req_config[key]
#             dicts1[key] = cookies1[key]
#
# print(dicts)
# print(dicts1)
# import random
# delay = random.randint(1, 1)
# print(dela


if __name__ == '__main__':
    # from yihai_scrapy.config import req_config
    # from yihai_scrapy.ip_proxy import IpProxy
    # import base64

    # proxy = IpProxy.get_proxy()
    # # 对代理进行加密认证
    # b64_up = base64.b64encode(IpProxy.user_password.encode())
    # 设置认证

    # url = "https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/space?offset=&host_mid=109710253"
    # headers = {
    #     "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
    # }

    # # temp = "buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc"
    # temp = req_config
    # temp = "header_theme_version=CLOSE; enable_web_push=DISABLE; buvid_fp_plain=undefined; buvid4=FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D; hit-dyn-v2=1; LIVE_BUVID=AUTO3217084866844183; FEED_LIVE_VERSION=V8; is-2022-channel=1; PVID=1; buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc; b_nut=1724036190; _uuid=1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc; CURRENT_BLACKGAP=0; fingerprint=32632d00a3c63b9592f1bff46463622c; rpdid=|(u|JkYY~JR)0J'u~k)JmJkm~; CURRENT_QUALITY=80; buvid_fp=32632d00a3c63b9592f1bff46463622c; home_feed_column=4; CURRENT_FNVAL=4048; bp_t_offset_1619277001=997018040052744192; bili_ticket=eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzEyNDA3MjMsImlhdCI6MTczMDk4MTQ2MywicGx0IjotMX0.l-5fgALs2AViWysnudfsXIFtaYQ7oQfgAkYJ4Cs6GpM; bili_ticket_expires=1731240663; b_lsid=98DB151F_19306926315; SESSDATA=54d15251%2C1746535415%2Ce25fa%2Ab1CjBNmX8RhMevvxxQyH2xvB_lzIBEpCorkeGrKKW6xc14Jhy4utsrLEQ8q4ljPiNIPS8SVk9wcVhTMUNlOExlZng3cTVEXzltODU4V05JaTViSWtnZk5OcUIwd213UVhNeWhXZlJGWkpjUnZfQTRBVnZJMEVKOTFTY2JuazlHcTdoQ2lKM3FGVkFBIIEC; bili_jct=0133314273a436efdb69f56c7a1e3293; DedeUserID=320899158; DedeUserID__ckMd5=91f0ee8638a6fe1a; sid=f5ra5f1d; browser_resolution=274-546"
    # temp="buvid3=2A3C82FE-3537-129D-C813-4CC1EC337B0C40587infoc"



    # # # temp = "header_theme_version=CLOSE; CURRENT_FNVAL=4048; rpdid=|(J|~uR|Jmkl0J'uYmku|YYRR; enable_web_push=DISABLE; buvid_fp_plain=undefined; buvid4=FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D; hit-dyn-v2=1; LIVE_BUVID=AUTO3217084866844183; FEED_LIVE_VERSION=V8; is-2022-channel=1; PVID=1; fingerprint=fb14b20ab08019acee6078daa7e2c91d; CURRENT_QUALITY=64; buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc; b_nut=1724920657; _uuid=1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc; bmg_af_switch=1; bmg_src_def_domain=i2.hdslb.com; bili_ticket=eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjQ5MTY1MjcsImlhdCI6MTcyNDY1NzI2NywicGx0IjotMX0.nY9E3EF-94RNARLdNPJWvTL5o-sd2AQW-AkRdYLWMGM; bili_ticket_expires=1734916467; b_lsid=8661FE9D_19197D08D86; bp_t_offset_320899158=970639922878742528; SESSDATA=c0a25122%2C1740385362%2C8f435%2A81CjBqvv1FXkXe9dxKAsPi5QIMcx-62BNCJZwhD5hY4D85VGR_BxRJjC4mLfUSJheGAHISVkxtUWFXQkZNZkNJYUFXMW5PekhSNnFCeUVYWHBEdmxtbUxQdnhHREwwYl9rTTVUV0gxUmE2MDdvMjcxUUVZaGdrS2U5blItdzYzSE9aN1FhRnBsZ3BRIIEC; bili_jct=b1841e60b8b183bd0b6d7fd285d06bde; DedeUserID=320899158; DedeUserID__ckMd5=91f0ee8638a6fe1a; buvid_fp=5e15f487d67c2bf2510d766483318b52; sid=6p42pf16; home_feed_column=4; browser_resolution=819-956"
    # # # # temp1 = "header_theme_version=CLOSE; CURRENT_FNVAL=4048; rpdid=|(J|~uR|Jmkl0J'uYmku|YYRR; enable_web_push=DISABLE; buvid_fp_plain=undefined; buvid4=FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D; hit-dyn-v2=1; LIVE_BUVID=AUTO3217084866844183; FEED_LIVE_VERSION=V8; is-2022-channel=1; PVID=1; fingerprint=fb14b20ab08019acee6078daa7e2c91d; CURRENT_QUALITY=64; buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc; b_nut=1724036190; _uuid=1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc; bmg_af_switch=1; bmg_src_def_domain=i2.hdslb.com; DedeUserID=320899158; DedeUserID__ckMd5=91f0ee8638a6fe1a; bp_t_offset_320899158=970662913838678016; bili_ticket=eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjUxNzQyMjksImlhdCI6MTcyNDkxNDk2OSwicGx0IjotMX0.5SndKDTIpbrvYHvLvEp7sSLmrdMic-3mDMQ2M9MUT5g; bili_ticket_expires=1725174169; SESSDATA=8f856492%2C1740471230%2C2e6d4%2A82CjC4yIb9OKWUyAY7h0NDFn8_uMPR8XYaDkYcIkJZGxzXhEpt1fDIWI4d8tB8dOtrW4kSVmw1TDFPb1h0akwyY3Q0andnOUJ6aFpkTUVlSHpLbXlaM0w2R3R1WU8zWUJFSzdxakJ0TmU2ZUE0THhpdlRYMjVSbGhQZm9SWk5lT20ycDY3STh0cUFRIIEC; bili_jct=05530fa211da8eab9ff4dffb4f1ab4c8; sid=5cjx9kor; b_lsid=4810AB2B9_1919D4C0BC9; buvid_fp=fb14b20ab08019acee6078daa7e2c91d; home_feed_column=4; browser_resolution=762-956"
    # req_config = {data.split('=')[0]: data.split('=')[1] for data in temp.split('; ')}
    # # cookies1 = {data.split('=')[0]: data.split('=')[1] for data in temp1.split('; ')}
    # # # print(req_config)
    # # data = requests.get(url=url, headers=headers, req_config=req_config)
    # # print(data.text)
    # # dicts = {"3":1,"2":2}
    # # import random
    # # data = random.choice(list(dicts.keys()))
    # # print(data)
    # print(req_config)
    # url = "https://api.bilibili.com/x/v2/reply/action"
    # data = {
    #     "oid": 1155193624,
    #     "type": 1,
    #     "rpid": 223860234096, # 评论id
    #     "action": 1,
    #     "csrf": "9e18a1b7d725a776be564081e33b11b5",
    #     "statistics": {"appId": 100, "platform": 5},
    # }
    # headers = {
    #     "Content-Type": "application/x-www-form-urlencoded",
    #     "Referer": "https://www.bilibili.com/video/BV1zZ421W7AN/?vd_source=0999087d41a18d40680b41e7dc8984b5&spm_id_from=player_end_recommend_autoplay",
    #     "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36 Edg/129.0.0.0"
    # }
    # # headers["Proxy-Authorization"] = 'Basic ' + b64_up.decode()
    # # proxies = {
    # #     'http': f'http://{IpProxy.user_password}@{proxy}',
    # #     'https': f'https://{IpProxy.user_password}@{proxy}'
    # # }
    # # print(proxies)
    # request = requests.post(url, data=data ,req_config=req_config,headers=headers)
    # res = request.content.decode()
    # print(res)
    from datetime import datetime

    # timestamp = 1730429873
    # def timestamp_to_time(timestamp):
    #     time_tuple = time.localtime(timestamp)
    #     return time.strftime("%Y-%m-%d %H:%M:%S", time_tuple)
    # data = timestamp_to_time(timestamp)
    # print(data)
    # first_page_pagination_str = {"offset": ""}
    # # first_page_pagination_str = {"offset":"{\"type\":1,\"direction\":1,\"session_id\":\"1772504715078972\",\"data\":{}}"}
    # pagination_str = Util.pagination_str(first_page_pagination_str)
    # # 构造时间戳
    # wts = int(time.time())
    # temps = [
    #     "mode=3",
    #     f"oid=113434079266810",
    #     f"pagination_str={pagination_str}",
    #     "plat=1",
    #     "seek_rpid=",
    #     "type=1",
    #     "web_location=1315875",
    #     f"wts={wts}",
    # ]
    # w_rid = Util.comment_decryption("&".join(temps))
    # # url = "https://api.bilibili.com/x/v2/reply/wbi/main?" + "&".join(temps) + f"&w_rid={w_rid}"
    # url = "https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/space?offset=&host_mid=109710253"
    #
    # print(url)
    #
    # # url = "https://www.bilibili.com/video/BV1xuDKYfEDL/?spm_id_from=333.337.search-card.all.click&vd_source=0999087d41a18d40680b41e7dc8984b5"
    # headers = {
    #     'User-Agent': "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0",
    #     "referer": None,
    # }
    # print(req_config)
    # proxy = IpProxy.get_proxy()
    # print(proxy)
    # proxies = {
    #     "http": f"http://{proxy}",
    #     "https": f"https://{proxy}"
    # }
    # from requests.auth import HTTPProxyAuth
    # auth = HTTPProxyAuth('d2501514560', 'fd9fjsz8')

    # response = requests.get(url=url, headers=headers, proxies=proxies)
    # response = requests.get(url=url, headers=headers,cookies=req_config)
    # # print(response.text)
    # data = response.json()
    # print(data)
    # for i in data["data"]["replies"]:
    #     print(i["content"]["message"])
    # # cookies = response.cookies
    # print(cookies)
    # for cookie in cookies:
    #     print(cookie)
    import re
    import json
    import subprocess
    from functools import partial

    subprocess.Popen = partial(subprocess.Popen, encoding="utf-8")
    import execjs

    with open('bilibili.html', 'r', encoding='utf-8') as f:
        text = f.read()
        # print(text)
        f.close()
    # pattern = r'window.__pinia=(.*)'
    match = re.findall(r'[window.](__pinia\s*=\s*\(function\([^)]*\)[^)]*\)[^<]*)', text)
    result = execjs.compile(match[0])
    resule = result.eval("__pinia")
    print(resule)
    # print(resule["searchTypeResponse"]["searchTypeResponse"]["result"])
    # print(len(resule["searchTypeResponse"]["searchTypeResponse"]["result"]))

    # print(len(match))

