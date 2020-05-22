# docker_mpd
FROM debian:stable-slim

LABEL version="3.1.6"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="mldonkey"
LABEL usage="https://github.com/J-Siu/docker_compose/blob/master/docker/mldonkey/README.md"

RUN apt update \
&& apt -y install tzdata mldonkey-server=3.1.6-1+b1 \
&& mkdir -p \
  /mld/.mldonkey \
  /mld/incoming \
  /mld/shared \
  /mld/temp \
  /mld/torrents

COPY docker-compose.yml env start.sh /
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]