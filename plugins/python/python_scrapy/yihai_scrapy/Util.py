import json
import execjs
from urllib import parse
import os
import string
import random

# 当前脚本绝对路径
current_dir = os.path.dirname(__file__)


# 字典转成紧凑的json
def dump_extension(extension):
    ext = json.dumps(extension, separators=(',', ':'))
    return ext


# 将评论的pagination_str字段从字典转换成指定格式的url编码（发请求用）
def pagination_str_req(text):
    # data = dump_extension(text)
    urllib_str = parse.quote(text)
    return urllib_str


# 将评论的pagination_str字段从字典转换成指定格式的url编码(获取加密w_rid用)
def pagination_str(text):
    data = dump_extension(text)
    urllib_str = parse.quote(data)
    return urllib_str


# 评论的w_rid加密
def comment_decryption(text):
    js_path = os.path.join(current_dir, 'javaScript/commentDecryption.js')
    with open(js_path, 'r', encoding='utf-8') as f:
        encrypt = f.read()
        w_rid = execjs.compile(encrypt).call('md5$2', text + "ea1db124af3c7062474693fa704f4ff8")
        f.close()
        return w_rid

# 游戏中心加密
def biligame_comment_decryption(text):
    js_path = os.path.join(current_dir, 'javaScript/commentDecryption.js')
    with open(js_path, 'r', encoding='utf-8') as f:
        encrypt = f.read()
        w_rid = execjs.compile(encrypt).call('md5$2', text + "BdiI92bjmZ9QRcjJBWv2EEssyjekAGKt")
        f.close()
        return w_rid

# 随机生成32长度的字符串
def generate_random_string(length=32):
    # 定义所有可用的字符，包括字母和数字
    characters = string.ascii_letters + string.digits
    # 随机选择字符并拼接成一个字符串
    return ''.join(random.choice(characters) for _ in range(length))


if __name__ == '__main__':
    # data = pagination_str({"offset": "{\"type\":1,\"direction\":1,\"session_id\":\"1763731491744834\",\"data\":{}}"})
    # print(data)
    # print(
    #     "%7B%22offset%22:%22%7B%5C%22type%5C%22:1,%5C%22direction%5C%22:1,%5C%22session_id%5C%22:%5C%221763731491744834%5C%22,%5C%22data%5C%22:%7B%7D%7D%22%7D")
    data = generate_random_string()
    print(data)
