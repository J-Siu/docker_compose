FROM alpine:edge

LABEL version="0.72.0-r0"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="hugo"
LABEL usage="https://github.com/J-Siu/docker_compose/blob/master/docker/hugo/README.md"

RUN apk --no-cache add ca-certificates ca-certificates-bundle tzdata
RUN apk --no-cache git hugo=0.72.0-r0

COPY README.md start.sh /
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
