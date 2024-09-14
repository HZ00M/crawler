import os
import sys
import subprocess

def main():
    venv_path = 'venv'
    script_path = 'scrapy crawl '
    config_list = sys.argv[1:]
    if len(config_list) == 0:
        print("缺少关键参数")
    script_path += config_list[0]
    config_list.pop(0)
    for config in config_list:
        script_path += " -a " + config
    print(script_path)

    if os.name == 'nt':
        activate_script = os.path.join(venv_path, 'Scripts', 'activate')
        command = f'cmd /c "{activate_script} && {script_path}"'
    elif os.name == 'posix':
        activate_script = os.path.join(venv_path, 'bin', 'activate')
        command = f'source {activate_script} && {script_path}'

    # 使用 subprocess.run 执行命令
    subprocess.run(command, shell=True)

if __name__ == '__main__':
    main()