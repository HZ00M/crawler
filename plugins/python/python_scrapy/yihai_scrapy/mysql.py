# -*- coding: utf-8 -*-
import pymysql
from pymysql import OperationalError, ProgrammingError
import psycopg2


class scrapy_sql:
    def __init__(self):
        self.conn = psycopg2.connect(
            dbname="crawler",
            user="postgres",
            password="123456",
            host="postgres",
            port=5432
        )

    def column_exists(self, cursor, table_name, column_name):
        query = f"""
        SELECT COUNT(*) 
        FROM information_schema.COLUMNS 
        WHERE TABLE_NAME = '{table_name}' 
          AND COLUMN_NAME = '{column_name}' 
          AND TABLE_SCHEMA = DATABASE()
        """
        cursor.execute(query)
        result = cursor.fetchone()
        return result[0] > 0

    def add_column_if_not_exists(self, cursor, table_name, column_name, column_type):
        if not self.column_exists(cursor, table_name, column_name):
            alter_query = f"ALTER TABLE {table_name} ADD COLUMN {column_name} {column_type} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
            cursor.execute(alter_query)
            print(f"Column '{column_name}' added to table '{table_name}'.")

    # 初始化表，如果新增字段，在这里设置
    def init_bilibili_table(self):
        create_table_sql = "CREATE TABLE IF NOT EXISTS bilibili (id INT AUTO_INCREMENT PRIMARY KEY)"
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(create_table_sql)
                self.add_column_if_not_exists(cursor, "bilibili", "类型", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "标题", 'VARCHAR(256)')
                self.add_column_if_not_exists(cursor, "bilibili", "视频详情", 'VARCHAR(256)')
                self.add_column_if_not_exists(cursor, "bilibili", "视频id", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "发布时间", 'VARCHAR(64)')
                self.add_column_if_not_exists(cursor, "bilibili", "发布人名字", 'VARCHAR(128)')
                self.add_column_if_not_exists(cursor, "bilibili", "视频播放量", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "弹幕量", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "点赞数", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "投硬币枚数", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "收藏人数", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "转发人数", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "视频简介", 'TEXT')
                self.add_column_if_not_exists(cursor, "bilibili", "标签", 'VARCHAR(1024)')
                self.add_column_if_not_exists(cursor, "bilibili", "视频话题", 'VARCHAR(128)')
                self.add_column_if_not_exists(cursor, "bilibili", "评论数", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "用户id", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "评论", 'TEXT')
                self.add_column_if_not_exists(cursor, "bilibili", "评论人", 'VARCHAR(128)')
                self.add_column_if_not_exists(cursor, "bilibili", "评论时间", 'VARCHAR(128)')
                self.add_column_if_not_exists(cursor, "bilibili", "评论点赞量", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "评论回复量", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "用户等级", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "用户会员", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "用户粉丝数", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "用户关注数", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "用户获赞数", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "用户简介", 'TEXT')
                self.add_column_if_not_exists(cursor, "bilibili", "开发者语录", 'TEXT')
                self.add_column_if_not_exists(cursor, "bilibili", "安卓最近更新", 'TEXT')
                self.add_column_if_not_exists(cursor, "bilibili", "ios最近更新", 'TEXT')
                self.add_column_if_not_exists(cursor, "bilibili", "评分", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "下载量", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "预约量", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "评论踩量", 'VARCHAR(32)')
                self.add_column_if_not_exists(cursor, "bilibili", "抓取时间", 'VARCHAR(32)')
            self.conn.commit()
        except OperationalError as e:
            print(f"OperationalError: {e}")
        except ProgrammingError as e:
            print(f"ProgrammingError: {e}")

    def insert(self, table_name, data_dict):
        del_list = []
        for key in data_dict:
            if data_dict[key] is None:
                del_list.append(key)
        for key in del_list:
            data_dict.pop(key)
        keys = ', '.join(data_dict.keys())
        placeholders = ', '.join(['%s'] * len(data_dict))
        sql = f"INSERT INTO {table_name} ({keys}) VALUES ({placeholders})"
        list_values = [str(value) for value in data_dict.values()]
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(sql, list_values)
                self.conn.commit()
        except Exception as e:
            print(f"sql insert error: {e}")

    def get_data(self):
        sql = f"SELECT * FROM t_job_record"
        with self.conn.cursor() as cursor:
            cursor.execute(sql)
            print(cursor.fetchone())
        self.close()

    def close(self):
        self.conn.close()


if __name__ == '__main__':
    # sql = scrapy_sql()
    # sql.init_bilibili_table()
    data = {"data_type": "游戏中心",
            "target_obj_id": 106852,
            "content": "欢迎光临黑犬大厅！全新地图探索玩法「碳酸爆破」上线！快来加入全新冒险吧！\n\n作为一款在运营多年的虚拟系统，我们致力于提供一流的意识接入服务。\n你将化身神秘特工在霓虹闪烁的地下世界中探险，自由选择探险路线，击败这个世界的神明。通过拾取各种奇妙道具，组成特点各异的流派，快速成长，体验激爽的弹幕射击。\n1. 道具叠加像开挂400+种道具武器无限叠加，强到逆天仿若开挂！\n2. 玩梗脑洞一大堆：GPT之神、短视频之神、爱豆之神……5G冲浪不掉线！\n3. 轻松欢乐联机与好友一起搭档冲锋、配合御敌，突破重重难关！\n4.花样闯关趣味多，舞蹈房、钢琴房，娃娃机房、钓鱼房丰富休闲趣味房间等你发现。",
            "title": "霓虹深渊：无限",
            "developer_word": "大家好，我是玄衣。\n诶嘿，来了来了。\n这里，先聊聊一些刚上线的版本，大家关心问题吧。\n新皮肤\n说到暑期，那首先就得要提到夏日系列的皮肤了。\n没错会有新的假日角色皮肤啦，放心，喜欢乱动的纳比斯已经被按住了，这次不是突然抢镜的迷之生物，是货真价实的小姐姐哦。\n当然，纱夜的夏日皮肤，也会在期间返场，喜欢的小伙伴不要错过哦。\n新角色\n那当然，暑期也会有新角色加入。\n而且和以往的角色不同，新角色拥有着一位“古老神祇”的名字，一位出自泰坦集团的人物，如今来到了反抗泰坦集团的阵营。\n这样的身份和来历，这怎么能让人安心呢。\n但似乎，她给出的理由，让人无法拒绝。\n她给出的条件，也让人无法拒绝。\n当然，或许有特工会说。\n她的人，更让人无法拒绝。\n总之，她的到来，将为特工们对抗泰坦集团的道路，带来重要的全新进展。\n毕竟现在大家的特工小队包过去，就是阿祖在泰坦大厦里也得吓得立即收手。\n在后续版本中，我们也有计划，让游戏的节奏，逐渐让游戏从招募小队，向反击泰坦集团开始过渡。\n（好想放图呀，但是包工头的刀在脖子上，感觉脖子凉凉的）\n新玩法\n说完了角色，既然带来了重要的线索，那特工们总得给做点什么对吧。\n在之前，想比大家都 已经注意到了，不夜之城，开始流行一种新的饮品了。\nHICOO。\n这家泰坦集团麾下的企业，突然冒出来，以几乎垄断的市场占有额，成为了不夜之城的焦点。\n但总有传闻，说HICOO可不是什么好东西。\n而这次，特工们将在新角色的邀请下，一同前往HICOO的总部大闹一场。\n至于详细的计划，到时候她自然会解释的。\n活动和福利\n最后，放心吧，暑期版本，都准备上了，少不了的，据说，是堪比周年庆级别的哦。\n嗯，那这次就先到这里了，详细的情况，等下次再细说吧，现在包工头盯得紧，图都被没收了。\n只能含恨下次再见了。\n不管怎么样，兑换码还是要有的：好想过暑假呀",
            "android_last_update": "【关卡相关】\n1、「碳酸爆破」模式新开放「机器之神」篇章。\n2、新开放「神经矩阵」S9赛季，开放时间：8月22日 6:00-10月16日 23:59\n\n【系统相关】\n1、「每日任务」功能全面优化，主要内容如下：\n①「每日任务」功能更名为「日常挑战」，新增「日常挑战」导航栏入口。\n②调整任务内容，移除部分体验不佳的任务，新增一批全新任务。\n③新增「每周任务」模块。\n2、优化「小助手经营」部分交互逻辑。",
            "ios_last_update": "",
            "tag": ["类Rogue", "rougelike", "赛博朋克", "steam移植", "地牢", "像素"],
            "mark": 8.0,
            "comments_count": 1224,
            "download_count": 211743,
            "book_num": 2082}
    # # # data = {"类型": "子评论"}
    sql = scrapy_sql()
    sqls = f"INSERT INTO t_job_record (title) VALUES (%s)"
    sql.insert("t_job_record",data)
    # sql.insert("bilibili",data)
    # conn = psycopg2.connect(
    #     dbname="crawler",
    #     user="postgres",
    #     password="123456",
    #     host="10.100.16.5432",
    #     port=5432
    # )
    # cur = conn.cursor()
    # sql = f"INSERT INTO t_job_record (title) VALUES (%s)"
    # cur.execute(sql, ["11"])
    # conn.commit()
    # sql = f"SELECT * FROM t_job_record"
    # cur.execute(sql)
    # rows = cur.fetchall()
    # for row in rows:
    #     print(row)


    # cur = scrapy_sql()
    # dicts = {"title": "霓虹新活动又更新啦，还不知道能白嫖哪些奖励？快来看看本期活动的白嫖统计吧！［霓虹深渊：无限］",
    #          "record_ur": "https://www.bilibili.com/video/BV1FJ4He9EyL/", "data_type": "视频",
    #          "msg_time": "2024-09-12 14:29:25", "author": "炫你一口糖", "user_id": "640735755", "content": "-",
    #          "tag": ["游戏", "单机游戏", "氪金攻略", "霓虹深渊"], "subject": [], "comments_count": None,
    #          "read_count": "2311", "barrage_count": "1", "like_count": "111", "coin_count": "41", "mark_count": "8",
    #          "share_count": "3", "target_obj_id": "113123130346470", "user_level": 5, "fans_count": 3647,
    #          "interest_count": 209, "user_likes": 14391, "user_describe": "糖糖霓虹交流2群群号：680639220",
    #          "user_member": "年度大会员"}
    # cur.insert('t_job_record', data)
    # cur.get_data()
    # cur.close()

    # sql.get_data()
    # sql.close()
    # data = [0,1,2,3,2]
    # data1 = tuple(data)
    # print(data1)
