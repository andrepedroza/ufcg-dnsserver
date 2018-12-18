FROM ubuntu:16.04

#Change timezone.
RUN ln -snf /usr/share/zoneinfo/America/Recife /etc/localtime && echo "America/Recife" > /etc/timezone

RUN apt update \
    && apt install -y vim supervisor wget unzip openjdk-8-jre-headless cron \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O /root/nxfilter.zip http://www.nxfilter.org/download/nxfilter-3.5.1.zip && mkdir -p /nxfilter && unzip /root/nxfilter.zip -d /nxfilter && rm /root/nxfilter.zip
RUN sed -i -e 's/Xmx512m/server/g' /nxfilter/bin/startup.sh
RUN chmod +x /nxfilter/bin/startup.sh && chmod +x /nxfilter/bin/update-sh.sh && chmod +x /nxfilter/bin/shutdown.sh
COPY cfg.properties /nxfilter/conf/cfg.properties
RUN cp -R /nxfilter/conf /nxfilter/conf.default

#Add cron job to update blacklist.
RUN echo '0 3 * * 0 root /bin/bash -c "/usr/bin/supervisorctl stop nxfilter && /nxfilter/bin/shutdown.sh && /nxfilter/bin/update-sh.sh && /usr/bin/supervisorctl start nxfilter"' > /etc/cron.d/update-blacklist

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY run.sh /

RUN chmod +x /run.sh

EXPOSE 80 443 53 53/udp

CMD ["/run.sh"]
