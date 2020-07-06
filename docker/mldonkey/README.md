Docker - mldonkey with UID and GID handling.

### Build

```sh
git clone https://github.com/J-Siu/docker_compose.git
cd docker/mldonkey
docker build -t jsiu/mldonkey .
```

### Usage

#### Host Directories and Volume Mapping

Host|Inside Container|Mapping Required|Usage
---|---|---|---
${MLD_CNF}|/mld/.mldonkey/|yes|mldonkey directory
${MLD_UID}|PUID|yes|amule uid
${MLD_GID}|PGID|yes|amule gid
${TZ}|P_TZ|yes|time zone

#### Run

```docker
docker run \
-d \
-e PUID=1001 \
-e PGID=1002 \
-e P_TZ=America/New_York \
-v /home/jsiu/.mldonkey:/mld/.mldonkey \
--network=host \
jsiu/mldonkey
```

#### Compose

Get docker-compose template from image:

```docker
docker run --rm jsiu/mldonkey cat /docker-compose.yml > docker-compose.yml
docker run --rm jsiu/mldonkey cat /env > .env
```

Fill in `.env` according to your environment.

```sh
docker-compose up
```

### Repository

- [docker_compose](https://github.com/J-Siu/docker_compose)

### Contributors

- [John Sing Dao Siu](https://github.com/J-Siu)

### Change Log

- 11025
  - mldonkey version 11025
<!--CHANGE-LOG-END-->

### License

The MIT License

Copyright (c) 2020

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
