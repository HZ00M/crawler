# 通用的配置
scrapy_config = {
    "霓虹深渊": {
        "name": "霓虹深渊",
        "video": True,  # 是否抓取视频
        "article": False,  # 是否抓取专栏
        "dynamic": False,  # 是否抓取动态
        "biliGame": False,  # 是否抓取游戏中心
        "UID": 109710253,  # 动态对应的用户id
        "gameId": 106852,  # 游戏中心对应的游戏id
        "sort_type": "2",  # 排序方式（视频/专栏，1代表默认排序，2代表发布时间）
        "app_key": "h9Ejat5tFh81cq8V",  # b站里的游戏appkey，拿评论要用到
    },
}

# 页面cookies,2天更新一次
cookies = "header_theme_version=CLOSE; rpdid=|(J|~uR|Jmkl0J'uYmku|YYRR; enable_web_push=DISABLE; buvid_fp_plain=undefined; buvid4=FD8003FC-6D45-A0CC-ADD4-E3267A807C6A11873-023081513-%2Fj7AVq8nv%2BlwD8SNCkyPQg%3D%3D; hit-dyn-v2=1; LIVE_BUVID=AUTO3217084866844183; FEED_LIVE_VERSION=V8; is-2022-channel=1; PVID=1; CURRENT_QUALITY=64; buvid3=F90F32C0-630E-C240-FF85-D7D05B7645EC90496infoc; b_nut=1724036190; _uuid=1584F499-DAA6-E10A7-D45F-76872CC821E991312infoc; DedeUserID=320899158; DedeUserID__ckMd5=91f0ee8638a6fe1a; bmg_af_switch=1; bmg_src_def_domain=i2.hdslb.com; fingerprint=7bd1bd60afa71ea5dbb7df3f91889676; CURRENT_BLACKGAP=0; CURRENT_FNVAL=4048; buvid_fp=7bd1bd60afa71ea5dbb7df3f91889676; bp_t_offset_320899158=975369755613462528; b_lsid=AD1F7216_191E4BDFB84; SESSDATA=6df828f3%2C1741675671%2C0d5b2%2A92CjBcwkdSSHNv5iNYlGmZHnWmSZUS69etvGIU2Jj1d2rQFiXrbDVpAfT2cMehpvbvKZ0SVkZ6SDdUcXRMM25SMlRnTU1xQjdFeDFJZzRvQWN4Q0JpeUlWZTRWTFAxTnhncUVCOTFmbHpiVFQ5NnF4NlgxcmtPMjB2SUdhLXJDa0lCbXVXUkhwTlJnIIEC; bili_jct=c74c595a748c594aa4ffa1c1925bcf1a; sid=pkudsio2; home_feed_column=4; browser_resolution=763-956"

# 各个页面网址相关
url_config = {
    "video": {
        "init_page": "https://search.bilibili.com/video?vt=14663435&keyword={keyword}&page={page}"
    },
    "article": {
        "init_page": "https://search.bilibili.com/article?vt=31691143&keyword={keyword}&page={page}"
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
