ss:
vi /etc/shadowsocks.json
ssserver -c /etc/shadowsocks.json -d restart

nginx:
nginx –t
-s reload
/etc/nginx/nginx.conf
blog:vim /etc/nginx/conf.d/default.conf

list server:
netstat -tulpn | grep LISTEN

健康：
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      10515/nginx: master
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1160/sshd
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      1119/master
tcp6       0      0 :::29615                :::*                    LISTEN      1009/v2ray
tcp6       0      0 :::80                   :::*                    LISTEN      10515/nginx: master
tcp6       0      0 :::29616                :::*                    LISTEN      1009/v2ray
tcp6       0      0 :::22                   :::*                    LISTEN      1160/sshd
tcp6       0      0 ::1:25                  :::*                    LISTEN      1119/master
tcp6       0      0 :::8989                 :::*                    LISTEN      1212/python
tcp6       0      0 :::8990                 :::*                    LISTEN      1212/python
tcp6       0      0 :::8991                 :::*                    LISTEN      1212/python
tcp6       0      0 :::4000                 :::*                    LISTEN      10207/docker-proxy-
tcp6       0      0 :::8992                 :::*                    LISTEN      1212/python
tcp6       0      0 :::8993                 :::*                    LISTEN      1212/python
tcp6       0      0 :::8994                 :::*                    LISTEN      1212/python
