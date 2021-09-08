FROM vergoh/vnstat
MAINTAINER Lee <noreply@lihaixin.name>

ENV MAXTX="950.50"
ENV MAXALL="1000"
ENV MAXLIMTYPE="GiB"


RUN set -ex \
    && apk --no-cache add vnstat \
    && sed -i '/UseLogging/s/2/0/' /etc/vnstat.conf \
    && sed -i '/RateUnit/s/1/0/' /etc/vnstat.conf

VOLUME /var/lib/vnstat

CMD ["vnstatd", "-n"]
