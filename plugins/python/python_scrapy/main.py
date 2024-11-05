import os
import sys
import subprocess
import time
import logging
from yihai_scrapy import logger
from yihai_scrapy.config import ip_config
from yihai_scrapy.config import req_config


def main():
    current_path = os.getcwd()
    venv_path = 'venv'
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
            config_list_a.remove(run_type)
        if "DOWNLOAD_DELAY" in run_type:
            setting_command += f" -s {run_type}"
            config_list_a.remove(run_type)

    # script_command += config_list[0]
    # config_list.pop(0)
    for config in config_list_a:
        script_command += " -a " + config
    # 如果有setting的配置，运行完毕后，单独加上setting的运行参数
    if setting_command:
        script_command += setting_command
    logging.info(script_command)

    # if os.name == 'nt':
    #     # 虚拟环境启动文件
    #     activate_script = os.path.join(venv_path, 'Scripts', 'activate')
    #     # 虚拟环境目录
    #     folder_path = os.path.join(current_path, "venv")
    #     # 判断虚拟环境目录是否存在，不存在就先创建一个，存在就直接运行
    #     if os.path.exists(folder_path) and os.path.isdir(folder_path):
    #         print(f"venv exists.")
    #         time.sleep(1)
    #         command = f'cmd /c "{activate_script} && {script_command}"'
    #     else:
    #         print(f"venv does not exist.")
    #         time.sleep(1)
    #         new_venv = f"python -m venv venv"
    #         pip_config = "pip config set global.index-url https://pypi.doubanio.com/simple"
    #         ins = "pip install -r requirements.txt"
    #         command = f'{new_venv} && cmd /c "{activate_script} && {pip_config} && {ins} && {script_command}"'
    # elif os.name == 'posix':
    #     activate_script = os.path.join(venv_path, 'bin', 'activate')
    #     folder_path = os.path.join(current_path, "venv")
    #     # 判断虚拟环境目录是否存在，不存在就先创建一个，存在就直接运行
    #     if os.path.exists(folder_path) and os.path.isdir(folder_path):
    #         print(f"venv exists.")
    #         time.sleep(1)
    #         # command = f'cmd /c "{activate_script} && {script_command}"'
    #         command = f'source {activate_script} && {script_command}'
    #     else:
    #         print(f"venv does not exist.")
    #         time.sleep(1)
    #         new_venv = f"python -m venv venv"
    #         pip_config = "pip config set global.index-url https://pypi.doubanio.com/simple"
    #         ins = "pip install -r requirements.txt"
    #         command = f'{new_venv} && source /c "{activate_script} && {pip_config} && {ins} && {script_command}"'
    #         # command = f'source {activate_script} && {script_command}'
    # # 使用 subprocess.run 执行命令
    # subprocess.run(command, shell=True)
    os.system(script_command)


if __name__ == '__main__':
    main()