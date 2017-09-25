FROM node

LABEL maintainer "akatebi"

# RUN apk update && apk add bash curl

ARG KIBANA=kibana-6.0.0-beta2-linux-x86_64
# ENV DEFAULT_KIBANA_USER=kibana

# RUN adduser -S $DEFAULT_KIBANA_USER

WORKDIR /home/kibana

ADD https://artifacts.elastic.co/downloads/kibana/${KIBANA}.tar.gz .

# RUN chown $DEFAULT_KIBANA_USER $KIBANA.tar.gz

# USER $DEFAULT_KIBANA_USER

RUN tar xvzf $KIBANA.tar.gz

RUN rm $KIBANA.tar.gz

EXPOSE 5601

WORKDIR /home/kibana/${KIBANA}

# RUN $(export GATEWAY=$(ip route | grep default | cut -d ' ' -f 3))
# ENV GATEWAY="172.17.0.1"

RUN sed -i 's/\#server\.host\: \"localhost\"/server\.host: 172.17.0.2/' config/kibana.yml

RUN sed -i 's/\#elasticsearch\.url\: \"http\:\/\/localhost\:9200\"/elasticsearch\.url\: \"http\:\/\/172.17.0.1\:9200\"/' config/kibana.yml

CMD ["./bin/kibana"]

# docker build -t akatebi/kibana - < Dockerfile
# docker run -p5601:5601 -d akatebi/kibana
