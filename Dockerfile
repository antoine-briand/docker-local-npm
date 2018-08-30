FROM node:10.9.0-alpine

MAINTAINER Orlando Hohmeier <hello@orlandohohmeier.com>

WORKDIR /local-npm
ADD . /local-npm/

RUN addgroup -S local-npm \
    && adduser -S -G local-npm local-npm

RUN npm set progress=false && npm install --no-color && npm dedupe

EXPOSE 5080
EXPOSE 16984

VOLUME /data

ENV BASE_URL='http://127.0.0.1:5080'
ENV DATA_DIRECTORY='/data'
ENV REMOTE_REGISTRY='https://registry.npmjs.org'
ENV REMOTE_REGISTRY_SKIMDB='https://skimdb.npmjs.com/registry'

CMD mkdir -p "$DATA_DIRECTORY" chmod 700 "$DATA_DIRECTORY" \
    && chown -R local-npm "$DATA_DIRECTORY" \
    && npm start -- --remote $REMOTE_REGISTRY \
    --remote-skim $REMOTE_REGISTRY_SKIMDB --directory $DATA_DIRECTORY \
    --url-base $BASE_URL
