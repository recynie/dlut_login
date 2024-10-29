# DLUT-login shell
生成登录大连理工大学校园网的shell脚本。
使用方法：
1. clone本仓库(`git clone https://github.com/recynie/dlut_login.git`)，进入仓库目录(`cd dlut_login`);
2. 将学号(`id`)、统一身份认证密码(`password`)填入`info.json`中;
3. 断开当前设备的校园网；
4. 运行`bash_gen.py`，生成`login.sh`脚本；
5. 赋予`login.sh`运行权限：`sudo chmod +x login.sh`；
6. 运行脚本登录校园网：`./login.sh`。

`template.sh`是shell的模板文件。

`login.sh`配合`crontab`命令可以实现物联网设备自动连接校园网。

shell参考了某个大佬的代码，找不到原仓库了:(

> 相关工具集：[DLUT-survival-tools](https://github.com/NAOSI-DLUT/dlut-survival-tools)
