FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y wget

RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb \
    && dpkg -i dumb-init_*.deb \
    && rm -f dumb-init_*.deb

RUN apt-get install -y supervisor

RUN apt-get install -y gettext-base

RUN wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.4.0-amd64.deb \
    && dpkg -i filebeat*.deb \
    && rm -f filebeat*.deb

RUN apt-get install -y logrotate
RUN sed -i 's/su root syslog/su root root/' /etc/logrotate.conf

COPY entry.sh /
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["bash", "-e", "/entry.sh"]

VOLUME /logs/
ENV ELASTICSEARCH_URL=elasticsearch:9200

# config files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY filebeat.yml.tpl /etc/filebeat/
COPY logrotate-all-logs.conf /etc/logrotate.d/
RUN chmod -x /etc/logrotate.d/*
