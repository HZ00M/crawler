# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class NeonScrapyItem(scrapy.Item):
    # define the fields for your item here like:
    # todo 新增的
    execute_id = scrapy.Field()  # 任务id
    execute_name = scrapy.Field()  # 任务名
    key_word = scrapy.Field()  # 搜索关键词


    web_site = scrapy.Field()  # 站点名称
    take_date = scrapy.Field()  # 发布日期
    msg_date = scrapy.Field()  # 爬取时间
    active_count = scrapy.Field()  # 总互动量
    user_homepage = scrapy.Field()  # 用户主页url


    data_type = scrapy.Field()  # 数据类型
    title = scrapy.Field()  # 标题
    target_obj_id = scrapy.Field()  # 分析对象id
    record_ur = scrapy.Field()
    # 视频id = scrapy.Field() # 暂时用分析对象id
    content = scrapy.Field()  # 内容
    msg_time = scrapy.Field()
    author = scrapy.Field()  # 作者
    read_count = scrapy.Field()
    barrage_count = scrapy.Field()
    like_count = scrapy.Field()
    coin_count = scrapy.Field()
    mark_count = scrapy.Field()
    share_count = scrapy.Field()
    tag = scrapy.Field()
    subject = scrapy.Field()
    comments_count = scrapy.Field()
    user_id = scrapy.Field()

    comment = scrapy.Field()
    commenter_name = scrapy.Field()
    comment_time = scrapy.Field()
    # 评论点赞量 = scrapy.Field()
    comment_reply_num = scrapy.Field()
    user_level = scrapy.Field()
    user_member = scrapy.Field()
    fans_count = scrapy.Field()
    interest_count = scrapy.Field()
    user_likes = scrapy.Field()
    user_describe = scrapy.Field()

    developer_word = scrapy.Field()
    android_last_update = scrapy.Field()
    ios_last_update = scrapy.Field()
    mark = scrapy.Field()
    download_count = scrapy.Field()
    book_num = scrapy.Field()
    down_count = scrapy.Field()
    take_time = scrapy.Field()

