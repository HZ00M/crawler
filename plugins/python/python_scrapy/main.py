import os
import sys
import subprocess
import time
import logging
from yihai_scrapy import logger
from yihai_scrapy.config import ip_config
from yihai_scrapy.config import req_config
from yihai_scrapy.cookies import ScrapyCookies


def main():
    # current_path = os.getcwd()
    # venv_path = 'venv'
    sc = ScrapyCookies("bilibili")
    script_command = 'scrapy crawl '
    setting_command = ""
    config_list = sys.argv[1:]
    config_list_a = [data for data in config_list]
    if len(config_list) == 0:
        logging.error("缺少关键参数")
        return
    for run_type in config_list:
        logging.info(run_type)
        if "type=" in run_type :
            scrapy_name = run_type.split("=")[1]
            script_command += scrapy_name
            config_list_a.remove(run_type)
            break
        # 如果传了ip数量
        if "ip_count" in run_type:
            ip_config["ip_count"] = int(run_type.split("=")[1])
            config_list_a.remove(run_type)
        if "cookies" in run_type:
            req_config["cookies"] = run_type.split("cookies=")[1]
            # sc.init_redis_cookies(req_config["cookies"])
            config_list_a.remove(run_type)
        if "DOWNLOAD_DELAY" in run_type:
            setting_command += f" -s {run_type}"
            config_list_a.remove(run_type)
    # 更新cookies
    # sc.update_config_cookies()
    # script_command += config_list[0]
    # config_list.pop(0)
    for config in config_list_a:
        script_command += " -a " + config
    # 如果有setting的配置，运行完毕后，单独加上setting的运行参数
    if setting_command:
        script_command += setting_command
    logging.info(script_command)
    # 命令行启动运行脚本
    os.system(script_command)

def taptap_review():
    script_command = 'scrapy crawl '
    setting_command = ""
    config_list = sys.argv[1:]
    config_list_a = [data for data in config_list]
    if len(config_list) == 0:
        logging.error("缺少关键参数")
        return
    for run_type in config_list:
        logging.info(run_type)
        if "type=" in run_type:
            scrapy_name = run_type.split("=")[1]
            script_command += scrapy_name
            config_list_a.remove(run_type)
            break
        # 如果传了ip数量
        if "ip_count" in run_type:
            ip_config["ip_count"] = int(run_type.split("=")[1])
            config_list_a.remove(run_type)
    for config in config_list_a:
        script_command += " -a " + config
    # 如果有setting的配置，运行完毕后，单独加上setting的运行参数
    if setting_command:
        script_command += setting_command
    logging.info(script_command)
    # 命令行启动运行脚本
    os.system(script_command)

if __name__ == '__main__':
    # runstr = "scrapy crawl bilibili -a key_word=霓虹深渊 -a model=1"
    for key in sys.argv[1:]:
        if "bilibili" in key:
            main()
            break
        elif "taptap" in key:
            taptap_review()
            break
    # os.system(runstr)
    # main()