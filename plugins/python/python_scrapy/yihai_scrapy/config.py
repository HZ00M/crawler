locast_debug = False

# 爬取数据配置，key=搜索的关键字
scrapy_config = {
    "霓虹深渊": {
        "name": "霓虹深渊",
        "video": True,  # 是否抓取视频
        "article": True,  # 是否抓取专栏
        "dynamic": True,  # 是否抓取动态
        "biliGame": True,  # 是否抓取游戏中心
        "UID": 109710253,  # 动态对应的用户id
        "gameId": 106852,  # 游戏中心对应的游戏id
        "sort_type": "2",  # 排序方式（视频/专栏，1代表默认排序，2代表发布时间）
        "app_key": "h9Ejat5tFh81cq8V",  # b站里的游戏appkey，拿评论要用到
    },
    "无悔华夏": {
        "name": "无悔华夏",
        "video": True,  # 是否抓取视频
        "article": True,  # 是否抓取专栏
        "dynamic": True,  # 是否抓取动态
        "biliGame": True,  # 是否抓取游戏中心
        "UID": 301793273,  # 动态对应的用户id
        "gameId": 106210,  # 游戏中心对应的游戏id
        "sort_type": "2",  # 排序方式（视频/专栏，1代表默认排序，2代表发布时间）
        "app_key": "h9Ejat5tFh81cq8V",  # b站里的游戏appkey，拿评论要用到
    },
    "新月同行": {
        "name": "新月同行",
        "video": True,  # 是否抓取视频
        "article": True,  # 是否抓取专栏
        "dynamic": True,  # 是否抓取动态
        "biliGame": True,  # 是否抓取游戏中心
        "UID": 1746158065,  # 动态对应的用户id
        "gameId": 109794,  # 游戏中心对应的游戏id
        "sort_type": "2",  # 排序方式（视频/专栏，1代表默认排序，2代表发布时间）
        "app_key": "h9Ejat5tFh81cq8V",  # b站里的游戏appkey，拿评论要用到
    },
}

# 请求参数,目前主要是cookies,2天更新一次
req_config = {
    "cookies": "SESSDATA=8c87db3a%2C1746862094%2Cfab81%2Ab1CjAQCCTMf3l8R-KGk9A0NMgGVvh-FFsPt2SksJvYeh5GUZjCImSto9dgscDM-gClk3ASVnUzZnRIUDVoRUlhZmhFMk5XbDZvcFBabXJ6MFUybWRoUWZaUy11bnI3VTRzLU90QzUxYVN2TkpsOHExN2Qzd1oyczhYRUl4dU40ZFFNdjM2Nmhtd05RIIEC"}

# 各个页面网址相关
url_config = {
    "video": {
        # "init_page": "https://search.bilibili.com/video?vt=14663435&keyword={keyword}&page={page}&o={num}"
        "init_page": "https://search.bilibili.com/video?vt=14663435&keyword={keyword}&pubtime_begin_s={begin_time}&pubtime_end_s={end_time}&page={page}&o={num}"
    },
    "article": {
        "init_page": "https://search.bilibili.com/article?vt=31691143&keyword={keyword}&page={page}",
        "detail_page": "https://www.bilibili.com/read/cv{article_id}/?from=search&spm_id_from=333.337.0.0"
    },
    "dynamic": {
        # 动态入口接口
        "entrance": "https://space.bilibili.com/{host_mid}/dynamic",
        # 动态初始界面（调接口拿到后续界面）
        "init_page": "https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/space?offset={offset}&host_mid={host_mid}",
        # 详情界面 （https://t.bilibili.com/964666847459803172?）
        "detail_page": "https://api.bilibili.com/x/polymer/web-dynamic/v1/detail?id={id}",
    },
    "biliGame": {
        # 莫得鬼用，啥信息都拿不到，仅输出到表里，给鱼吉看
        "init_page": "https://www.biligame.com/detail/?id={id}",
        # 评论界面
        "replay_page": "https://line1-h5-pc-api.biligame.com/game/comment/page?",
        "reply_sign": "appkey={appkey}&game_base_id={game_base_id}&page_num={page_num}&page_size=10&rank_type={rank_type}&request_id={request_id}&ts={ts}",
        # 子评论界面
        "sub_replay_page": "https://line1-h5-pc-api.biligame.com/game/comment/reply/page?",
        "sub_reply_sign": "appkey={appkey}&comment_no={comment_no}&game_base_id={game_base_id}&page_num={page_num}&page_size=10&request_id={request_id}&ts={ts}",
        # 详情界面（描述，tag, 近期更新等）
        "detail_page": "https://line1-h5-pc-api.biligame.com/game/detail/content?game_base_id={id}",
        # 总结（评分，评论数）
        "summary_page": "https://line1-h5-pc-api.biligame.com/game/comment/summary?",
        "summer_sign": "appkey={appkey}&game_base_id={game_base_id}&request_id={request_id}&ts={ts}",
        # 预约，下载信息
        "game_info": "https://line1-h5-pc-api.biligame.com/game/detail/gameinfo?game_base_id={id}"
    }
}

# 随机代理ip参数
ip_config = {
    # 订单的账号密码
    "user_password": "d2501514560:fd9fjsz8",
    # 订单id
    "secret_id": "ofcljov0wrq9oj5tyu28",
    # 订单的secret_key，调用接口必备
    "secret_key": "y0z5vxgbakbqc0lxl8vrlld9eumhxyw1",
    # 使用多少个ip进行随机
    "ip_count": 5
}

# sql参数
sql_config = {
    "dbname": "crawler",
    "user": "postgres",
    "password": "123456",
    "host": "postgres" if not locast_debug else "10.100.16.111",
    "port": 5432
}

# redis参数
redis_config = {
    "host":"10.100.16.103",
    "port":30379,
    "db":0,
    "decode_responses":True,
    # 用户存储的key
    "bilibili":"bilibili:user"
}