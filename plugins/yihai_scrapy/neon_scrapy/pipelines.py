# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html
import time

# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
import json
from neon_scrapy.mysql import scrapy_sql


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
        self.file.write(f"{self.index}:" + json_data)
        self.index += 1
        return item

    def close_spider(self, spider):
        self.file.write("}")
        self.file.close()


class mysqlPipeline:
    def open_spider(self, spider):
        self.scaapy_sql = scrapy_sql()

    def process_item(self, item, spider):
        # 把对象转换成字典，并将字典序列化
        now_time = time.time()
        item["take_time"] = int(now_time)
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
