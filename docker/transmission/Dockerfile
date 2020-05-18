# docker_mpd
FROM alpine:edge

LABEL version="2.94"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="transmission"
LABEL usage="https://github.com/J-Siu/docker_compose/blob/master/docker/transmission/README.md"

RUN apk update \
&& apk --no-cache add tzdata transmission-daemon=2.94-r4 \
&& mkdir -p /transmission/Downloads

COPY docker-compose.yml env start.sh /
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]