# import execjs
#
# with open('commentDecryption.js','r',encoding='utf-8') as f:
#     jquary = f.read()
#     ctx = execjs.compile(jquary).call('md5$2',"2")
#     print(ctx)
#     f.close()
import requests
import time
from neon_scrapy import Util
from neon_scrapy import items
import redis
import pymysql
from pymysql import OperationalError, ProgrammingError


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
# from neon_scrapy.config import cookies
# # if __name__ == '__main__':
#
# url2 = "https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/space?offset=959804510703714360&host_mid=109710253"
# url = "https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/space?offset=&host_mid=109710253"
# headers = {
#     "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
# }
# # temp = "buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc"
# temp = cookies
# temp = {'header_theme_version': 'CLOSE', 'rpdid': "|(J|~uR|Jmkl0J'uYmku|YYRR", 'enable_web_push': 'DISABLE', 'buvid_fp_plain': 'undefined', 'buvid4': 'FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D', 'hit-dyn-v2': '1', 'LIVE_BUVID': 'AUTO3217084866844183', 'FEED_LIVE_VERSION': 'V8', 'is-2022-channel': '1', 'PVID': '1', 'CURRENT_QUALITY': '64', 'buvid3': 'F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc', 'b_nut': '1724036190', '_uuid': '1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc', 'DedeUserID': '320899158', 'DedeUserID__ckMd5': '91f0ee8638a6fe1a', 'bili_ticket': 'eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjU1MDA3OTIsImlhdCI6MTcyNTI0MTUzMiwicGx0IjotMX0.AZE8MU5RLKku6u_iasdPCARz5jLWVbD11zL6mUT5HkI', 'bili_ticket_expires': '1725500732', 'SESSDATA': '64ef28b1%2C1740793594%2Cc6caa%2A92CjCznTnzYgrUEEb7C_7UZgFBMmtsYPWGQOriJQdKll5fqX9IE-s8su5xiqYHFxWOLf8SVlN4VmFIY1BQU2xTWWpueTFuN2E0bzc5VW80ZkF4QmNoRlRCNkVSdG5wODBMTjVpOEQzcDJMVUZBb0NSVDRJczcwdTV5WmVlTUpQLThFYTl3RFdSQ2tBIIEC', 'bili_jct': '58f46a89b1426fbf784706a4ead12ec6', 'sid': '8teq1fn9', 'bp_t_offset_320899158': '972400442858274816', 'bmg_af_switch': '1', 'bmg_src_def_domain': 'i2.hdslb.com', 'fingerprint': '7bd1bd60afa71ea5dbb7df3f91889676', 'buvid_fp': '7bd1bd60afa71ea5dbb7df3f91889676', 'CURRENT_BLACKGAP': '0', 'CURRENT_FNVAL': '16', 'b_lsid': '77A3D10EC_191BBDE8458', 'home_feed_column': '4', 'browser_resolution': '763-956'}
# # temp = "header_theme_version=CLOSE; CURRENT_FNVAL=4048; rpdid=|(J|~uR|Jmkl0J'uYmku|YYRR; enable_web_push=DISABLE; buvid_fp_plain=undefined; buvid4=FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D; hit-dyn-v2=1; LIVE_BUVID=AUTO3217084866844183; FEED_LIVE_VERSION=V8; is-2022-channel=1; PVID=1; fingerprint=fb14b20ab08019acee6078daa7e2c91d; CURRENT_QUALITY=64; buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc; b_nut=1724920657; _uuid=1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc; bmg_af_switch=1; bmg_src_def_domain=i2.hdslb.com; bili_ticket=eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjQ5MTY1MjcsImlhdCI6MTcyNDY1NzI2NywicGx0IjotMX0.nY9E3EF-94RNARLdNPJWvTL5o-sd2AQW-AkRdYLWMGM; bili_ticket_expires=1734916467; b_lsid=8661FE9D_19197D08D86; bp_t_offset_320899158=970639922878742528; SESSDATA=c0a25122%2C1740385362%2C8f435%2A81CjBqvv1FXkXe9dxKAsPi5QIMcx-62BNCJZwhD5hY4D85VGR_BxRJjC4mLfUSJheGAHISVkxtUWFXQkZNZkNJYUFXMW5PekhSNnFCeUVYWHBEdmxtbUxQdnhHREwwYl9rTTVUV0gxUmE2MDdvMjcxUUVZaGdrS2U5blItdzYzSE9aN1FhRnBsZ3BRIIEC; bili_jct=b1841e60b8b183bd0b6d7fd285d06bde; DedeUserID=320899158; DedeUserID__ckMd5=91f0ee8638a6fe1a; buvid_fp=5e15f487d67c2bf2510d766483318b52; sid=6p42pf16; home_feed_column=4; browser_resolution=819-956"
# # temp1 = "header_theme_version=CLOSE; CURRENT_FNVAL=4048; rpdid=|(J|~uR|Jmkl0J'uYmku|YYRR; enable_web_push=DISABLE; buvid_fp_plain=undefined; buvid4=FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D; hit-dyn-v2=1; LIVE_BUVID=AUTO3217084866844183; FEED_LIVE_VERSION=V8; is-2022-channel=1; PVID=1; fingerprint=fb14b20ab08019acee6078daa7e2c91d; CURRENT_QUALITY=64; buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc; b_nut=1724036190; _uuid=1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc; bmg_af_switch=1; bmg_src_def_domain=i2.hdslb.com; DedeUserID=320899158; DedeUserID__ckMd5=91f0ee8638a6fe1a; bp_t_offset_320899158=970662913838678016; bili_ticket=eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjUxNzQyMjksImlhdCI6MTcyNDkxNDk2OSwicGx0IjotMX0.5SndKDTIpbrvYHvLvEp7sSLmrdMic-3mDMQ2M9MUT5g; bili_ticket_expires=1725174169; SESSDATA=8f856492%2C1740471230%2C2e6d4%2A82CjC4yIb9OKWUyAY7h0NDFn8_uMPR8XYaDkYcIkJZGxzXhEpt1fDIWI4d8tB8dOtrW4kSVmw1TDFPb1h0akwyY3Q0andnOUJ6aFpkTUVlSHpLbXlaM0w2R3R1WU8zWUJFSzdxakJ0TmU2ZUE0THhpdlRYMjVSbGhQZm9SWk5lT20ycDY3STh0cUFRIIEC; bili_jct=05530fa211da8eab9ff4dffb4f1ab4c8; sid=5cjx9kor; b_lsid=4810AB2B9_1919D4C0BC9; buvid_fp=fb14b20ab08019acee6078daa7e2c91d; home_feed_column=4; browser_resolution=762-956"
# # cookies = {data.split('=')[0]: data.split('=')[1] for data in temp.split('; ')}
# # cookies1 = {data.split('=')[0]: data.split('=')[1] for data in temp1.split('; ')}
# # print(cookies)
# data = requests.get(url=url, headers=headers, cookies=temp)
# data2 = requests.get(url=url2, headers=headers, cookies=cookies)
# print(data.text)
# print(data2.text)
# dicts = {}
# dicts1 = {}
# for key in cookies:
#     if key in cookies1:
#         if cookies[key] == cookies1[key]:
#             continue
#         else:
#             dicts[key] = cookies[key]
#             dicts1[key] = cookies1[key]
#
# print(dicts)
# print(dicts1)
# import random
# delay = random.randint(1, 1)
# print(dela


if __name__ == '__main__':
    # from neon_scrapy.config import cookies
    # url = "https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/space?offset=&host_mid=109710253"
    # headers = {
    #     "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
    # }
    # # temp = "buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc"
    # temp = cookies
    # # temp = {'header_theme_version': 'CLOSE', 'rpdid': "|(J|~uR|Jmkl0J'uYmku|YYRR", 'enable_web_push': 'DISABLE', 'buvid_fp_plain': 'undefined', 'buvid4': 'FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D', 'hit-dyn-v2': '1', 'LIVE_BUVID': 'AUTO3217084866844183', 'FEED_LIVE_VERSION': 'V8', 'is-2022-channel': '1', 'PVID': '1', 'CURRENT_QUALITY': '64', 'buvid3': 'F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc', 'b_nut': '1724036190', '_uuid': '1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc', 'DedeUserID': '320899158', 'DedeUserID__ckMd5': '91f0ee8638a6fe1a', 'bili_ticket': 'eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjU1MDA3OTIsImlhdCI6MTcyNTI0MTUzMiwicGx0IjotMX0.AZE8MU5RLKku6u_iasdPCARz5jLWVbD11zL6mUT5HkI', 'bili_ticket_expires': '1725500732', 'SESSDATA': '64ef28b1%2C1740793594%2Cc6caa%2A92CjCznTnzYgrUEEb7C_7UZgFBMmtsYPWGQOriJQdKll5fqX9IE-s8su5xiqYHFxWOLf8SVlN4VmFIY1BQU2xTWWpueTFuN2E0bzc5VW80ZkF4QmNoRlRCNkVSdG5wODBMTjVpOEQzcDJMVUZBb0NSVDRJczcwdTV5WmVlTUpQLThFYTl3RFdSQ2tBIIEC', 'bili_jct': '58f46a89b1426fbf784706a4ead12ec6', 'sid': '8teq1fn9', 'bp_t_offset_320899158': '972400442858274816', 'bmg_af_switch': '1', 'bmg_src_def_domain': 'i2.hdslb.com', 'fingerprint': '7bd1bd60afa71ea5dbb7df3f91889676', 'buvid_fp': '7bd1bd60afa71ea5dbb7df3f91889676', 'CURRENT_BLACKGAP': '0', 'CURRENT_FNVAL': '16', 'b_lsid': '77A3D10EC_191BBDE8458', 'home_feed_column': '4', 'browser_resolution': '763-956'}
    # # temp = "header_theme_version=CLOSE; CURRENT_FNVAL=4048; rpdid=|(J|~uR|Jmkl0J'uYmku|YYRR; enable_web_push=DISABLE; buvid_fp_plain=undefined; buvid4=FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D; hit-dyn-v2=1; LIVE_BUVID=AUTO3217084866844183; FEED_LIVE_VERSION=V8; is-2022-channel=1; PVID=1; fingerprint=fb14b20ab08019acee6078daa7e2c91d; CURRENT_QUALITY=64; buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc; b_nut=1724920657; _uuid=1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc; bmg_af_switch=1; bmg_src_def_domain=i2.hdslb.com; bili_ticket=eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjQ5MTY1MjcsImlhdCI6MTcyNDY1NzI2NywicGx0IjotMX0.nY9E3EF-94RNARLdNPJWvTL5o-sd2AQW-AkRdYLWMGM; bili_ticket_expires=1734916467; b_lsid=8661FE9D_19197D08D86; bp_t_offset_320899158=970639922878742528; SESSDATA=c0a25122%2C1740385362%2C8f435%2A81CjBqvv1FXkXe9dxKAsPi5QIMcx-62BNCJZwhD5hY4D85VGR_BxRJjC4mLfUSJheGAHISVkxtUWFXQkZNZkNJYUFXMW5PekhSNnFCeUVYWHBEdmxtbUxQdnhHREwwYl9rTTVUV0gxUmE2MDdvMjcxUUVZaGdrS2U5blItdzYzSE9aN1FhRnBsZ3BRIIEC; bili_jct=b1841e60b8b183bd0b6d7fd285d06bde; DedeUserID=320899158; DedeUserID__ckMd5=91f0ee8638a6fe1a; buvid_fp=5e15f487d67c2bf2510d766483318b52; sid=6p42pf16; home_feed_column=4; browser_resolution=819-956"
    # # temp1 = "header_theme_version=CLOSE; CURRENT_FNVAL=4048; rpdid=|(J|~uR|Jmkl0J'uYmku|YYRR; enable_web_push=DISABLE; buvid_fp_plain=undefined; buvid4=FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D; hit-dyn-v2=1; LIVE_BUVID=AUTO3217084866844183; FEED_LIVE_VERSION=V8; is-2022-channel=1; PVID=1; fingerprint=fb14b20ab08019acee6078daa7e2c91d; CURRENT_QUALITY=64; buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc; b_nut=1724036190; _uuid=1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc; bmg_af_switch=1; bmg_src_def_domain=i2.hdslb.com; DedeUserID=320899158; DedeUserID__ckMd5=91f0ee8638a6fe1a; bp_t_offset_320899158=970662913838678016; bili_ticket=eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjUxNzQyMjksImlhdCI6MTcyNDkxNDk2OSwicGx0IjotMX0.5SndKDTIpbrvYHvLvEp7sSLmrdMic-3mDMQ2M9MUT5g; bili_ticket_expires=1725174169; SESSDATA=8f856492%2C1740471230%2C2e6d4%2A82CjC4yIb9OKWUyAY7h0NDFn8_uMPR8XYaDkYcIkJZGxzXhEpt1fDIWI4d8tB8dOtrW4kSVmw1TDFPb1h0akwyY3Q0andnOUJ6aFpkTUVlSHpLbXlaM0w2R3R1WU8zWUJFSzdxakJ0TmU2ZUE0THhpdlRYMjVSbGhQZm9SWk5lT20ycDY3STh0cUFRIIEC; bili_jct=05530fa211da8eab9ff4dffb4f1ab4c8; sid=5cjx9kor; b_lsid=4810AB2B9_1919D4C0BC9; buvid_fp=fb14b20ab08019acee6078daa7e2c91d; home_feed_column=4; browser_resolution=762-956"
    # cookies = {data.split('=')[0]: data.split('=')[1] for data in temp.split('; ')}
    # # cookies1 = {data.split('=')[0]: data.split('=')[1] for data in temp1.split('; ')}
    # # print(cookies)
    # data = requests.get(url=url, headers=headers, cookies=cookies)
    # print(data.text)
    dicts = {"3":1,"2":2}
    import random
    data = random.choice(list(dicts.keys()))
    print(data)