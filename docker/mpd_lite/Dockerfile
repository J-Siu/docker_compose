# docker_mpd_lite
FROM alpine:latest as build_base

LABEL version="0.21.23"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="mpd_lite"
LABEL usage="https://github.com/J-Siu/docker_compose/blob/master/docker/mpd_lite/README.md"

RUN wget http://www.musicpd.org/download/mpd/0.21/mpd-0.21.23.tar.xz / && tar xf mpd-0.21.23.tar.xz
WORKDIR /mpd-0.21.23

RUN apk --no-cache add build-base boost ninja boost-dev meson alsa-lib-dev sqlite-dev ffmpeg-dev \
	&& meson . output/release \
		--prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
		--localstatedir=/var \
		--buildtype=release \
		-Dcue=true \
		-Ddatabase=true \
		-Depoll=true \
		-Deventfd=true \
		-Dfifo=true \
		-Dinotify=true \
		-Dpipe=true \
		-Dsignalfd=true \
		-Dtcp=true \
		-Dalsa=enabled \
		-Dffmpeg=enabled \
		-Dipv6=enabled \
		-Dsqlite=enabled \
		-Ddaemon=false \
		-Dsyslog=disabled \
		-Dlocal_socket=false \
		-Ddocumentation=false \
		-Ddsd=false \
		-Dhttpd=false \
		-Dneighbor=false \
		-Drecorder=false \
		-Dtest=false \
		-Dwave_encoder=false \
		-Dadplug=disabled \
		-Dao=disabled \
		-Daudiofile=disabled \
		-Dbzip2=disabled \
		-Dcdio_paranoia=disabled \
		-Dchromaprint=disabled \
		-Dcurl=disabled \
		-Ddbus=disabled \
		-Dexpat=disabled \
		-Dfaad=disabled \
		-Dflac=disabled \
		-Dfluidsynth=disabled \
		-Dgme=disabled \
		-Diconv=disabled \
		-Dicu=disabled \
		-Did3tag=disabled \
		-Diso9660=disabled \
		-Djack=disabled \
		-Dlame=disabled \
		-Dlibmpdclient=disabled \
		-Dlibsamplerate=disabled \
		-Dmad=disabled \
		-Dmikmod=disabled \
		-Dmms=disabled \
		-Dmodplug=disabled \
		-Dmpcdec=disabled \
		-Dmpg123=disabled \
		-Dnfs=disabled \
		-Dopenal=disabled \
		-Dopus=disabled \
		-Doss=disabled \
		-Dpcre=disabled \
		-Dpulse=disabled \
		-Dqobuz=disabled \
		-Dshine=disabled \
		-Dshout=disabled \
		-Dsidplay=disabled \
		-Dsmbclient=disabled \
		-Dsndfile=disabled \
		-Dsndio=disabled \
		-Dsolaris_output=disabled \
		-Dsoundcloud=disabled \
		-Dsoxr=disabled \
		-Dsystemd=disabled \
		-Dtidal=disabled \
		-Dtremor=disabled \
		-Dtwolame=disabled \
		-Dudisks=disabled \
		-Dupnp=disabled \
		-Dvorbis=disabled \
		-Dvorbisenc=disabled \
		-Dwavpack=disabled \
		-Dwebdav=disabled \
		-Dwildmidi=disabled \
		-Dyajl=disabled \
		-Dzeroconf=disabled \
		-Dzlib=disabled \
		-Dzzip=disabled \
	&& meson configure output/release \
	&& ninja -C output/release

FROM alpine:latest

LABEL version="0.21.23"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="mpd_lite"
LABEL usage="https://github.com/J-Siu/docker_compose/blob/master/docker/mpd_lite/README.md"

COPY --from=build_base /mpd-0.21.23/output/release/mpd /usr/bin/
RUN apk update \
	&& apk --no-cache add alsa-lib sqlite-libs ffmpeg-libs

COPY docker-compose.yml env start.sh mpd.conf /
RUN chmod u+x /start.sh \
	&& chmod ugo+x /usr/bin/mpd \
	&& mkdir /mpd

EXPOSE 6600

CMD ["/start.sh"]