FROM --platform=${TARGETPLATFORM} lihaixin/base:3.16

LABEL author="Teemu Toivola and sanjin"
LABEL repository.reference.git="https://github.com/vergoh/vnstat-docker"
LABEL repository.reference.docker="https://hub.docker.com/r/vergoh/vnstat"
ENV TZ=Asia/Shanghai
ENV DOCKERID=VNSTAT

ENV MAXTX="950"
ENV MAXALL="1000"
ENV MAXLIMTYPE="GiB"
ENV RATE 1mbit
ENV BURST 2kb
ENV LATENCY 50ms

ENV HTTP_PORT=8586
ENV HTTP_BIND=*
ENV HTTP_LOG=/dev/stdout
ENV LARGE_FONTS=0
ENV CACHE_TIME=1
ENV RATE_UNIT=1
ENV PAGE_REFRESH=0

RUN apk add --no-cache tzdata ca-certificates perl gd sqlite-libs lighttpd tini iproute2 bash figlet curl \
 && ln -s /usr/lib/tc /lib/tc \
 && apk add --no-cache --virtual TMP gcc pkgconf gd-dev make musl-dev sqlite-dev linux-headers git \
 && git clone --depth 1 https://github.com/vergoh/vnstat \
 && cd vnstat/ \
 && ./configure --prefix=/usr --sysconfdir=/etc --disable-dependency-tracking \
 && make && make install \
 && cp -v examples/vnstat.cgi /var/www/localhost/htdocs/index.cgi \
 && cp -v examples/vnstat-json.cgi /var/www/localhost/htdocs/json.cgi \
 && cd .. \
 && rm -fr vnstat* \
 && apk del TMP \
 && addgroup -S vnstat && adduser -S -h /var/lib/vnstat -s /sbin/nologin -g vnStat -D -H -G vnstat vnstat
 
RUN echo '*/5 * * * * bash /limit_bandwidth.sh >/etc/vnstat.log 2>&1' >>/var/spool/cron/crontabs/root \
 && chown root:cron /var/spool/cron/crontabs/root \
 && chmod 600 /var/spool/cron/crontabs/root

VOLUME /var/lib/vnstat
EXPOSE ${HTTP_PORT}


COPY favicon.ico /var/www/localhost/htdocs/favicon.ico
ADD ./.bashrc /root/.bashrc
COPY limit_bandwidth.sh /limit_bandwidth.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh /limit_bandwidth.sh
ENTRYPOINT ["/entrypoint.sh"]
