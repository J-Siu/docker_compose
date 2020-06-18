# docker_mpd
FROM alpine:edge

LABEL version="3.00-r0-p1"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="transmission"
LABEL usage="https://github.com/J-Siu/docker_compose/blob/master/docker/transmission/README.md"
LABEL description="Docker - transmission with UID/GID handling, and optional Transmission Web Control"

RUN apk --no-cache add tzdata transmission-daemon=3.00-r0 \
&& mkdir -p /transmission

COPY docker-compose.yml env start.sh /
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]