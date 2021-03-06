#!/bin/sh -e
#   --------------------------------------------------------------
#	系统支持: Alpine 3.10+
#	作    者: sbblog
#	博    客: https://www.sbblog.cn/
#	开源地址：https://github.com/sbblog/file/linux
#	基于Alpine一键安装 Nginx+PHP7+Sqlite3 环境 （支持VPS最小内存32M）
#   --------------------------------------------------------------

echo -e "系统支持: Alpine 3.10+"
echo -e "作    者: sbblog"
echo -e "博    客: https://www.sbblog.cn/"
echo -e "基于Alpine一键安装 Nginx+PHP7+Sqlite3 环境 （支持VPS最小内存32M）"
echo -e "开源地址：https://github.com/sbblog/file/linux"
echo -e ""
echo -e ""
echo -e ""

apk update

# 安装 nginx
apk add nginx
rm /etc/nginx/conf.d/default.conf
wget -P /etc/nginx/conf.d https://raw.githubusercontent.com/sbblog/file/master/linux/conf/default.conf

# 安装 php7 和 sqlite数据库
apk add php7 php7-mysqli php7-pdo_mysql php7-mbstring php7-json php7-zlib php7-gd php7-intl php7-session php7-fpm php7-memcached php7-tokenizer php7-ctype php7-sqlite3 php7-pdo_sqlite

sed -i "s@^memory_limit.*@memory_limit = 5M@" /etc/php7/php.ini
sed -i 's@^output_buffering =@output_buffering = On\noutput_buffering =@' /etc/php7/php.ini
sed -i 's@^;cgi.fix_pathinfo.*@cgi.fix_pathinfo=1@' /etc/php7/php.ini
sed -i 's@^short_open_tag = Off@short_open_tag = On@' /etc/php7/php.ini
sed -i 's@^expose_php = On@expose_php = Off@' /etc/php7/php.ini
sed -i 's@^request_order.*@request_order = "CGP"@' /etc/php7/php.ini
sed -i 's@^;date.timezone.*@date.timezone = Asia/Shanghai@' /etc/php7/php.ini
sed -i 's@^post_max_size.*@post_max_size = 100M@' /etc/php7/php.ini
sed -i 's@^upload_max_filesize.*@upload_max_filesize = 50M@' /etc/php7/php.ini
sed -i 's@^max_execution_time.*@max_execution_time = 600@' /etc/php7/php.ini
sed -i 's@^;realpath_cache_size.*@realpath_cache_size = 2M@' /etc/php7/php.ini
sed -i 's@^disable_functions.*@disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsocket,popen@' /etc/php7/php.ini


# 创建目录
mkdir /home/wwwroot
mkdir /home/wwwroot/default

# 重启php7 并添加开机启动
/etc/init.d/php-fpm7 restart
rc-update add php-fpm7

# 重启nginx 并添加开机启动
/etc/init.d/nginx restart
rc-update add nginx

cat > /home/wwwroot/default/index.php << EOF
<?php phpinfo(); ?>
EOF

netstat -ntlp

echo -e ""
echo -e ""
echo -e ""
echo -e "安装完成，通过IPv4即可访问默认页面，如果你是nat vps 或者 IPv6的vps"
echo -e "请修改 /etc/nginx/conf.d/default.conf 第五行端口为其他端口，删除第六行的 # 则开启IPv6支持"
echo -e "修改nginx的配置文件，每次都需要重启nginx才会生效：/etc/init.d/nginx restart"
echo -e "重启php7的命令是：/etc/init.d/php-fpm7 restart"
echo -e "默认路径：/home/wwwroot/default，你可以把程序放在这里面。"
