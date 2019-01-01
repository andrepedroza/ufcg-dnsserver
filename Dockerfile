FROM ubuntu:16.04

#Change timezone.
RUN ln -snf /usr/share/zoneinfo/America/Recife /etc/localtime && echo "America/Recife" > /etc/timezone

RUN apt update \
    && apt install -y vim wget unzip openjdk-8-jre-headless \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O /root/nxfilter.zip http://www.nxfilter.org/download/nxfilter-3.5.1.zip && mkdir -p /nxfilter && unzip /root/nxfilter.zip -d /nxfilter && rm /root/nxfilter.zip
RUN sed -i -e 's/Xmx512m/server/g' /nxfilter/bin/startup.sh
RUN chmod +x /nxfilter/bin/startup.sh && chmod +x /nxfilter/bin/update-sh.sh && chmod +x /nxfilter/bin/shutdown.sh
COPY cfg.properties /nxfilter/conf/cfg.properties
RUN cp -R /nxfilter/conf /nxfilter/conf.default

COPY run.sh /

RUN chmod +x /run.sh

EXPOSE 80 443 53 53/udp

CMD ["/run.sh"]
