FROM alpine:3.15

RUN apk add wget libxml2-utils xmlstarlet zip bash

ENV PATH /scripts:$PATH
ENV CONFIG_FILE /config/config.xml
ENV NO_CBZ ""

WORKDIR /manga/

COPY ./scripts/ /scripts

CMD dl-config.sh
