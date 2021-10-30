vnstat
======

[vnStat][1] vnStat 是一个网络流量监视器，它使用内核提供的网络接口统计信息作为信息源。这意味着 vnStat 实际上不会嗅探任何流量，并且无论网络流量率如何，都可以确保少量使用系统资源。

默认情况下，流量统计信息存储在过去 48 小时的 5 分钟级别、过去 4 天的每小时级别、过去 2 整个月的每日级别以及永远的年度级别。数据保留持续时间完全由用户配置。还提供了总看到流量和前几天列表。

程序
=======
1. vnStat 守护进程 ( vnstatd) 作为主进程运行
2. lighttpdvnstati通过 http提供 vnStat 图像输出 ( )（默认情况下所有接口上的端口 8685）
3. vnStat 命令行 ( vnstat)
4. crond 监控是否超流量
5. tc 超流量限速度到1m

###
```bash
docker build -t lihaixin/vnstat .

docker run -d --name vnstat \
--restart=unless-stopped \
--net host \
--privileged \
-v /etc/localtime:/etc/localtime:ro \
-v /etc/timezone:/etc/timezone:ro \
-v vnstatdb:/var/lib/vnstat \
-e MAXTX=1.8 \
-e MAXALL=4.0 \
-e MAXLIMTYPE=TiB \
lihaixin/vnstat

docker  exec vnstat bash
>>> vnstat --help
>>> vnstati --help
>>> exit
```
docker-compose.yml
```
version: "3.7"
services:

  vnstat:
    image: lihaixin/vnstat:latest
    container_name: vnstat
    restart: unless-stopped
    network_mode: "host"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - vnstatdb:/var/lib/vnstat
    environment:
      - HTTP_PORT=8685
      - HTTP_BIND=*
      - HTTP_LOG=/dev/stdout
      - LARGE_FONTS=0
      - CACHE_TIME=1
      - RATE_UNIT=1
      - PAGE_REFRESH=0

volumes:
  vnstatdb:
  
```

[1]: http://humdi.net/vnstat/
