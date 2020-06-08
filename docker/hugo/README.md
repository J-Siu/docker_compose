Docker - Hugo site generator to be used in CI/CD.

### Build

```sh
git clone https://github.com/J-Siu/docker_compose.git
cd docker/hugo
docker build -t jsiu/hugo .
```

### Usage

#### Host Directories and Volume Mapping

Host|Inside Container|Mapping Required|Usage
---|---|---|---
${PUB_DIR}|/public|yes|Hugo public will be copied here
${GIT_URL}|${GIT_URL}|yes|Hugo will work inside this dir
${GIT_SUB}|${GIT_SUB}|no|Define this if sub-module need to be pulled
${TZ}|${P_TZ}|no|time zone

#### Run

```docker
docker run \
-e P_TZ=America/New_York \
-e GIT_URL=${GIT_URL} \
-v ${PUB_DIR}:/public \
jsiu/hugo
```

#### Compose

Get `REAME.md` from image:

```docker
docker run --rm jsiu/hugo cat /README.md > README.md
```

### Repository

- [docker_compose](https://github.com/J-Siu/docker_compose)

### Contributors

- [John Sing Dao Siu](https://github.com/J-Siu)

### Change Log

- 1.0
  - Initial commit.

### License

The MIT License

Copyright (c) 2020

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
