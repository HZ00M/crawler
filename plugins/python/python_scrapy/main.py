import os
import sys
import subprocess
import time


def main():
    current_path = os.getcwd()
    venv_path = 'venv'
    script_command = 'scrapy crawl '
    config_list = sys.argv[1:]
    if len(config_list) == 0:
        print("缺少关键参数")
        return
    script_command += config_list[0]
    config_list.pop(0)
    for config in config_list:
        script_command += " -a " + config
    print(script_command)

    # if os.name == 'nt':
    #     activate_script = os.path.join(venv_path, 'Scripts', 'activate')
    #     command = f'cmd /c "{activate_script} && {script_command}"'
    if os.name == 'nt':
        # 虚拟环境启动文件
        activate_script = os.path.join(venv_path, 'Scripts', 'activate')
        # 虚拟环境目录
        folder_path = os.path.join(current_path, "venv")
        # 判断虚拟环境目录是否存在，不存在就先创建一个，存在就直接运行
        if os.path.exists(folder_path) and os.path.isdir(folder_path):
            print(f"venv exists.")
            time.sleep(1)
            command = f'cmd /c "{activate_script} && {script_command}"'
        else:
            print(f"venv does not exist.")
            time.sleep(1)
            new_venv = f"python -m venv venv"
            pip_config = "pip config set global.index-url https://pypi.doubanio.com/simple"
            ins = "pip install -r requirements.txt"
            command = f'{new_venv} && cmd /c "{activate_script} && {pip_config} && {ins} && {script_command}"'
    elif os.name == 'posix':
        activate_script = os.path.join(venv_path, 'bin', 'activate')
        folder_path = os.path.join(current_path, "venv")
        # 判断虚拟环境目录是否存在，不存在就先创建一个，存在就直接运行
        if os.path.exists(folder_path) and os.path.isdir(folder_path):
            print(f"venv exists.")
            time.sleep(1)
            # command = f'cmd /c "{activate_script} && {script_command}"'
            command = f'source {activate_script} && {script_command}'
        else:
            print(f"venv does not exist.")
            time.sleep(1)
            new_venv = f"python -m venv venv"
            pip_config = "pip config set global.index-url https://pypi.doubanio.com/simple"
            ins = "pip install -r requirements.txt"
            command = f'{new_venv} && source /c "{activate_script} && {pip_config} && {ins} && {script_command}"'
            # command = f'source {activate_script} && {script_command}'

    # 使用 subprocess.run 执行命令
    subprocess.run(command, shell=True)

if __name__ == '__main__':
    main()