[![Docker Build & Publish](https://github.com/itaru2622/android-studio/actions/workflows/build_publish.yml/badge.svg)](https://github.com/itaru2622/android-studio/actions/workflows/build_publish.yml)

## basic use example on linux
```bash
# top_dir in below is the folder to share files between docker host and container, such as projects, android-sdk, envrironment files( .android, .config in container Home)
yourhost$ top_dir=${HOME}/Work/android

# prepare folders
yourhost$ mkdir -p ${top_dir}/dot-android ${top_dir}/dot-config ${top_dir}/sdk ${top_dir}/projects 
# allow to display android studio on yourhost
yourhost$ xhost +

# run container
yourhost$ docker run --name android-studio -it --rm --network host --privileged \
            -v ${top_dir}/sdk:/home/android/Android/Sdk \
            -v ${top_dir}/dot-android:/home/android/.android \
            -v ${top_dir}/dot-config:/home/android/.config \
            -v ${top_dir}/projects:/home/android/AndroidStudioProjects \
            -e ANDROID_HOME=/home/android/Android/Sdk \
            -e DISPLAY=${DISPLAY} \
            itaru2622/android-studio:bookworm /bin/bash

# start android studio
inContainer$ studio.sh
```

## build and use your own image on linux

- requires: make

```bash
# install requirements
yourhost$ sudo apt install make

# check Dockerfile and Makefile, then execute below:
yourhost$ make build
yourhost$ make run

inContainer$ studio.sh
```
