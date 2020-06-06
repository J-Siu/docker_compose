# docker_mpd
FROM alpine:edge

LABEL version="1.0"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="postfix"
LABEL usage="https://github.com/J-Siu/docker_compose/blob/master/docker/postfix/README.md"

RUN apk update && \
	apk --no-cache add ca-certificates ca-certificates-bundle tzdata \
		cyrus-sasl \
		cyrus-sasl-crammd5 \
		cyrus-sasl-digestmd5 \
		cyrus-sasl-gs2 \
		cyrus-sasl-gssapiv2 \
		cyrus-sasl-login \
		cyrus-sasl-ntlm \
		cyrus-sasl-plain \
		cyrus-sasl-scram \
		postfix && \
	tar cjf /postfix.pkg.tgz -C /etc postfix && \
	rm -rf /etc/postfix

COPY docker-compose.yml env start.sh /
RUN chmod +x /start.sh

CMD ["/start.sh"]
