FROM alpine:edge

LABEL version="2.9"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="hostapd"
LABEL usage="https://github.com/J-Siu/docker_compose/blob/master/docker/hostapd/README.md"

RUN apk update \
	&& apk --no-cache add hostapd=2.9-r1

COPY docker-compose.yml env /

CMD ["hostapd","/hostapd.conf"]
