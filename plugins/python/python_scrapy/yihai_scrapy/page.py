"""
所有的元素定位，统一写在这个类里，后续便于维护
"""

class bilibiliPage:
    # 视频列表
    video_list = '//div[@id="i_cecream"]//div[@class="video-list row"]/div'
    # 视频标题(相对视频列表单个视频的定位)
    video_title = './/h3[@class="bili-video-card__info--tit"]/@title'
    # 视频详情地址(相对视频列表单个视频的定位)
    video_details = './div/div[2]/a/@href'

    # 视频详情界面
    # 视频发布时间
    posted_time = '//*[@id="viewbox_report"]/div[@class="video-info-meta"]/div/div[@class="pubdate-ip item"]/div/text()'
    # up主名字
    up_name = '//*[@id="mirror-vdcon"]//div[@class="up-panel-container"]//div[@class="up-detail-top"]/a[1]/text()'
    # up主id
    up_id = '//*[@id="mirror-vdcon"]/div[2]/div/div[1]/div[1]/div[1]/div/a/@href'
    # 视频简介
    video_introduction = '//*[@id="v_desc"]/div/span/text()'
    # 视频标签
    video_tag = '//*[@class="video-tag-container"]/div//a/text()[normalize-space()]'
    # 视频话题
    video_topic = '//*[@class="video-tag-container"]/div//a/@title'
    # 视频热度（视频播放量/弹幕量/点赞数/投币数/收藏人数/转发人数）
    video_heat = '/html/head/meta[@name="description"]/@content'
    # 视频评论人数
    video_comment_num = '//*[@id="comment"]/div/bili-comments'
    # ------------------------ 专栏分界线 ---------------------------
    # 专栏列表(页面渲染出来的，得自己解析)
    article_list = '//body/script[@type="text/javascript"][1]/text()'
    # 专栏详情界面的初始信息（后续页面根据这个进行渲染，页面上的xpath定位都是错误的）
    article_html_info = '//body/script[1]/text()'
