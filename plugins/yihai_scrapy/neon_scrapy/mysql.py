import pymysql
from pymysql import OperationalError, ProgrammingError
import psycopg2


class scrapy_sql:
    def __init__(self):
        self.conn = pymysql.connect(
            database="crawler",
            user="root",
            password="password",
            host="10.100.2.228",
            port=30006
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
        keys = ', '.join(data_dict.keys())
        placeholders = ', '.join(['%s'] * len(data_dict))
        sql = f"INSERT INTO {table_name} ({keys}) VALUES ({placeholders})"
        list_values = [str(value) for value in data_dict.values()]
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(sql, list_values)
                self.conn.commit()
        except Exception as e:
            print(e)

    def get_data(self):
        sql = f"SELECT * FROM bilibili where id = 1"
        with self.conn.cursor() as cursor:
            cursor.execute(sql)
            print(cursor.fetchone())
        self.close()

    def close(self):
        self.conn.close()


if __name__ == '__main__':
    # sql = scrapy_sql()
    # sql.init_bilibili_table()
    # data = {
    #     "标题": "［新套装测评：灵魂尖塔］时隔半年，霓虹再次迎来六边形数值大户！？会是新一代的版本之神吗？b站最详细的新套装全方位解析［霓虹深渊：无限］",
    #     "视频详情": "https://www.bilibili.com/video/BV1CEWUetEFz/", "类型": "视频", "发布时间": "2024-08-23 14:42:57",
    #     "发布人名字": "炫你一口糖", "用户id": "640735755", "视频简介": "-",
    #     "标签": ["游戏", "手机游戏", "攻略", "套装", "游戏测评", "版本", "霓虹深渊"], "视频话题": [], "评论数": None,
    #     "视频播放量": "10668", "弹幕量": "85", "点赞数": "254", "投硬币枚数": "98", "收藏人数": "87", "转发人数": "26",
    #     "视频id": "113009900914397", "用户等级": 5, "用户粉丝数": 3486, "用户关注数": 204, "用户获赞数": 13650,
    #     "用户简介": "糖糖霓虹交流2群群号：680639220", "开发者语录": "年度大会员"}
    # # # data = {"类型": "子评论"}
    # sql.insert("bilibili",data)
    conn = psycopg2.connect(
        dbname="crawler",
        user="postgres",
        password="123456",
        host="10.100.0.220",
        port=5432
    )
    cur = conn.cursor()

    # sql.get_data()
    # sql.close()
    # data = [0,1,2,3,2]
    # data1 = tuple(data)
    # print(data1)
