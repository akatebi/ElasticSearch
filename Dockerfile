FROM openjdk:8-jre-alpine

LABEL maintainer "akatebi"

RUN apk update && apk add bash curl

ARG ES=elasticsearch-6.0.0-beta2
# avoid conflicts with debian host systems when mounting to host volume
ARG DEFAULT_ES_USER_UID=1100
ENV DEFAULT_ES_USER=elasticsearch
ENV ES_JAVA_OPTS="-Xms1g -Xmx1g"

RUN adduser -S -u $DEFAULT_ES_USER_UID $DEFAULT_ES_USER

WORKDIR /home/elasticsearch

ADD https://artifacts.elastic.co/downloads/elasticsearch/$ES.tar.gz .

RUN chown $DEFAULT_ES_USER $ES.tar.gz

USER $DEFAULT_ES_USER

RUN tar xvzf $ES.tar.gz

RUN rm $ES.tar.gz

HEALTHCHECK --timeout=5s \
  CMD curl http://$HOSTNAME:9200/_cat/health

VOLUME ["/data","/conf"]

EXPOSE 9200 9300

WORKDIR /home/elasticsearch/${ES}

# Switch to container's external address
RUN sed -i 's/\#network\.host\: 192\.168\.0\.1/network\.host: \$\{HOSTNAME\}/' config/elasticsearch.yml

CMD ["./bin/elasticsearch"]

# docker build -t akatebi/elasticsearch - < Dockerfile
# docker run -p9200:9200 -p9300:9300 -d akatebi/elasticsearch
