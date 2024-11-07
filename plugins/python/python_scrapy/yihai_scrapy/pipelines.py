# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html
import time

# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
import json

from scrapy import item

from yihai_scrapy.mysql import scrapy_sql
from yihai_scrapy.config import redis_config
import redis


class NeonScrapyPipeline:
    def open_spider(self, spider):
        self.file = open('bilibili1.json', 'w', encoding="utf-8")
        self.file.write("{")
        self.index = 1

    def process_item(self, item, spider):
        # 把对象转换成字典，并将字典序列化
        item = dict(item)
        json_data = json.dumps(item, ensure_ascii=False) + ',\n'
        # 将数据写入文件
        self.file.write(f"\"{self.index}\":" + json_data)
        self.index += 1
        return item

    def close_spider(self, spider):
        self.file.write("}")
        self.file.close()


class MysqlPipeline:
    def open_spider(self, spider):
        self.scaapy_sql = scrapy_sql()

    def process_item(self, item, spider):
        # 把对象转换成字典，并将字典序列化
        time_tuple = time.localtime(int(time.time()))
        now_time = time.strftime("%Y-%m-%d %H:%M:%S", time_tuple)
        item["take_time"] = now_time
        # 启动传过来的几个参数
        if spider.key_word:
            item["key_word"] = spider.key_word
        if spider.execute_id:
            item["execute_id"] = spider.execute_id
        if spider.execute_name:
            item["execute_name"] = spider.execute_name
        item["web_site"] = spider.name
        item = dict(item)
        # name = spider.name
        name = "t_job_record"
        self.scaapy_sql.insert(name, item)
        return item

    def close_spider(self, spider):
        self.scaapy_sql.close()


class RedisPipeline:
    def open_spider(self, spider):
        self.redis = redis.StrictRedis(host=redis_config["host"], port=redis_config["port"], db=redis_config["db"],
                                       decode_responses=redis_config["decode_responses"])
        # 新增用户数据
        self.bilibili_new_user_dicts = {}

    def process_item(self, item, spider):
        # 如果是没有存入的/超过30天的，重新存一次
        now_time = int(time.time())
        if "user_id" in item:
            user_id = str(item['user_id'])
            if user_id not in spider.bilibili_user_dicts or json.loads(spider.bilibili_user_dicts[user_id])[
                "save_time"] < now_time - 86400 * 30:
                self.bilibili_new_user_dicts[user_id] = json.dumps({
                    "user_level": item["user_level"],
                    "fans_count": item["fans_count"],
                    "interest_count": item["interest_count"],
                    "user_likes": item["user_likes"],
                    "user_describe": item["user_describe"],
                    "user_member": item["user_member"],
                    "user_homepage": item["user_homepage"],
                    "save_time": now_time,
                })
        # 存一定用户后，存一波
        if len(self.bilibili_new_user_dicts) > 30:
            self.redis.hset(redis_config["bilibili"], mapping=self.bilibili_new_user_dicts)
            self.bilibili_new_user_dicts.clear()
            spider.bilibili_user_dicts = self.redis.hgetall(redis_config["bilibili"])

    # 脚本结束的时候，把新增的/有变动的用户信息存进去
    def close_spider(self, spider):
        if self.bilibili_new_user_dicts:
            self.redis.hset(redis_config["bilibili"], mapping=self.bilibili_new_user_dicts)
