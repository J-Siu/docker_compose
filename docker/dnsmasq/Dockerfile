FROM alpine:edge

LABEL version="1.0"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="dnsmasq"
LABEL usage="https://github.com/J-Siu/docker_compose/blob/master/docker/dnsmasq/README.md"

RUN apk update \
	&& apk --no-cache add dnsmasq=2.81-r0

COPY docker-compose.yml env /

ENTRYPOINT ["dnsmasq","--no-daemon"]
