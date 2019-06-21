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
