FROM alpine:3.7
MAINTAINER Lee <noreply@lihaixin.name>
LABEL CLASS NET


RUN set -ex \
    && apk --no-cache add vnstat \
    && sed -i '/UseLogging/s/2/0/' /etc/vnstat.conf \
    && sed -i '/RateUnit/s/1/0/' /etc/vnstat.conf

VOLUME /var/lib/vnstat

CMD ["vnstatd", "-n"]
