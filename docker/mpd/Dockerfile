# docker_mpd
FROM alpine:edge

LABEL version="0.21.22"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="mpd"
LABEL usage="https://github.com/J-Siu/docker_compose/blob/master/docker/mpd/README.md"

RUN apk update \
	&& apk --no-cache add mpd=0.21.22-r2

COPY docker-compose.yml env start.sh mpd.conf /
RUN chmod u+x /start.sh \
	&& mkdir /mpd

EXPOSE 6600

CMD ["/start.sh"]