# alpine-s6-docker
An [alpine](https://hub.docker.com/_/alpine/) based docker image with [s6-overlay](https://github.com/just-containers/s6-overlay/).

> This build uses `docker buildx` plugin with `docker-container` driver.<br>
> This uses the [tonistiigi/binfmt](https://github.com/tonistiigi/binfmt "tonistiigi/binfmt") emulator plugin. <br>
> Docker image available at [swarupsengupta2007/alpine-s6](https://hub.docker.com/r/swarupsengupta2007/alpine-s6 "swarupsengupta2007/alpine-s6").

```bash
# clone this repo
git clone https://github.com/swarupsengupta2007/alpine-s6-docker
```

# Building<br>
1. Ensure buildx is enabled for docker.
2. Create a builder instance for multi-arch.
3. Ensure cross-platform emulators are installed.
4. Build docker image for current platform or multi-arch.

```bash
# choose target platforms
TARGETS="linux/amd64,linux/386,linux/arm64,linux/arm/v7,linux/arm/v6"

# create a builder instance if it doesn't exists
docker buildx create --name cross-platform --platform ${TARGETS} --use  

# Install cross platform emulators if not already instaled
docker run --privileged --rm tonistiigi/binfmt --install all

# build for current platform and load to docker image
docker buildx build -t <your_tag> . --load

# build for multi-arch and push to registry
docker buildx build -t <your_username>/<your_tag> --platform ${TARGETS} . --push
```

Build-args available
|build-arg|default|Description|
|--|--|--|
|DEF_USER|appuser|user created for this image|
|DEF_GROUP|appuser|group created for this image's user|
|DEF_UID|1000|UID of the DEF_USER|
|DEF_GID|1000|GID of the DEF_USER|
|DEF_CONFIG|/config|config director, also serves as volume|
|DEF_APP|/app|app directory used to store app's binary/scripts|
|DEF_DEFAULTS|/defaults|defaults directory for containing greenfield configurations|
|BASE_VERSION|3.16.0|os version to use as base|
|BASE_OS|alpine|option to change base os (untested)|
---

# Usage

## Using docker-cli <br>
```bash
sudo docker run 
    --rm                          \
    -it                           \
    -v /path/to/config:/config    \
    swarupsengupta2007/alpine-s6  \
    sh
```

The following Environment var are available<br>
|ENV variable|Description|Default|
|--|--|--|
|PUID|The UID for DEF_USER|1000|
|PGID|The GID for DEF_USER|1000|
