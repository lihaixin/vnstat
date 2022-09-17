## 构建

```
docker buildx build --platform linux/arm64,linux/amd64 -t lihaixin/vnstat . --push
```

# vnstat

[vnStat][1] vnStat 是一个网络流量监视器，它使用内核提供的网络接口统计信息作为信息源。这意味着 vnStat 实际上不会嗅探任何流量，并且无论网络流量率如何，都可以确保少量使用系统资源。

默认情况下，流量统计信息存储在过去 48 小时的 5 分钟级别、过去 4 天的每小时级别、过去 2 整个月的每日级别以及永远的年度级别。数据保留持续时间完全由用户配置。还提供了总看到流量和前几天列表。

## 功能

1. vnStat 守护进程 ( vnstatd) 作为主进程运行
2. lighttpdvnstati通过 http提供 vnStat 图像输出 ( )（默认情况下所有接口上的端口 8685）
3. vnStat 命令行 ( vnstat)
4. crond 监控是否超流量
5. tc 超流量限速度到1m

## 安装

### CLI 安装
```bash

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
### docker-compose.yml  限制月流量2T模板
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
      - HTTP_PORT=0                             # http服务器端口,或者调整8685，用于0禁用http服务器
      - HTTP_BIND=*                             # 用于绑定http服务器的IP地址，用于127.0.0.1仅绑定到本地主机并防止远程访问
      - HTTP_LOG=/dev/stdout                    # Http服务器日志输出文件，/dev/stdout用于输出到控制台和/dev/null禁用日志记录
      - LARGE_FONTS=0                           # 在图像中使用大字体（0：否，1：是）
      - CACHE_TIME=1                            # 在给定的分钟数内缓存创建的图像（0：禁用）
      - RATE_UNIT=1                             # 使用的流量速率单位，0：字节，1：比特
      - PAGE_REFRESH=0                          # 页面自动刷新间隔以秒为单位（0：禁用）
      - MAXTX=1.8                               # 最大传出流量,默认为G
      - MAXALL=3.5                              # 进出双向最大流量.默认为G
      - MAXLIMTYPE=TiB                          # 流量统计单位
      - RATE=1mbit                              # 流量超过设定值后限制最大的带宽
      - BURST=2kb                               # 令牌桶的大小
      - LATENCY=50ms                            # 数据请求超过令牌通,等待多久的延迟,如果延迟时间到,还没有令牌,就丢弃

volumes:
  vnstatdb:
  
```

[1]: http://humdi.net/vnstat/
