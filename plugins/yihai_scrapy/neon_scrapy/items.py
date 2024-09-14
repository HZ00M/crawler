# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class NeonScrapyItem(scrapy.Item):
    # define the fields for your item here like:
    类型 = scrapy.Field()
    标题 = scrapy.Field()
    视频详情 = scrapy.Field()
    视频id = scrapy.Field()
    发布时间 = scrapy.Field()
    发布人名字 = scrapy.Field()
    视频播放量 = scrapy.Field()
    弹幕量 = scrapy.Field()
    点赞数 = scrapy.Field()
    投硬币枚数 = scrapy.Field()
    收藏人数 = scrapy.Field()
    转发人数 = scrapy.Field()
    视频简介 = scrapy.Field()
    标签 = scrapy.Field()
    视频话题 = scrapy.Field()
    评论数 = scrapy.Field()
    用户id = scrapy.Field()

    评论 = scrapy.Field()
    评论人 = scrapy.Field()
    评论时间 = scrapy.Field()
    评论点赞量 = scrapy.Field()
    评论回复量 = scrapy.Field()
    用户等级 = scrapy.Field()
    用户会员 = scrapy.Field()
    用户粉丝数 = scrapy.Field()
    用户关注数 = scrapy.Field()
    用户获赞数 = scrapy.Field()
    用户简介 = scrapy.Field()

    开发者语录 = scrapy.Field()
    安卓最近更新 = scrapy.Field()
    ios最近更新 = scrapy.Field()
    评分 = scrapy.Field()
    下载量 = scrapy.Field()
    预约量 = scrapy.Field()
    评论踩量 = scrapy.Field()
    抓取时间 = scrapy.Field()



