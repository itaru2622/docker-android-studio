
# docker host directory for building android app
top_dir=/tmp/android
top_dir=${HOME}/Work/android

# UID and UserName for container
uid=1000
uname=android

# directories in container (defaults of studio.sh)
sdk_dir=/home/${uname}/Android/Sdk
pj_dir=/home/${uname}/AndroidStudioProjects

# docker names, container and image
container_name=android-studio
img_name=itaru2622/android-studio:bullseye

# android-studio version to use.
ver_studio=2021.3.1.16


# targes for ops. >>>>>>>>>>>>>>>>>>>>>>>>>>>>

run: _prep
	docker run --name ${container_name} -it --rm --network host --privileged \
  	-v ${top_dir}/sdk:${sdk_dir} \
  	-v ${top_dir}/dot-android:/home/${uname}/.android \
  	-v ${top_dir}/dot-config:/home/${uname}/.config \
  	-v ${top_dir}/projects:${pj_dir} \
  	-e ANDROID_HOME=${sdk_dir} \
        -e DISPLAY=${DISPLAY} \
        -w ${pj_dir} \
	${img_name} /bin/bash

build:
	docker build --build-arg uid=${uid}  --build-arg uname=${uname} --build-arg ver_studio=${ver_studio} -t ${img_name} .

runwith_daemon: _prep
	docker run --name ${container_name} -itd --restart always --network host --privileged --user root \
  	-v ${top_dir}/sdk:${sdk_dir} \
  	-v ${top_dir}/dot-android:/home/${uname}/.android \
  	-v ${top_dir}/dot-config:/home/${uname}/.config \
  	-v ${top_dir}/projects:${pj_dir} \
  	-e ANDROID_HOME=${sdk_dir} \
        -w ${pj_dir} \
	${img_name} /sbin/init

	docker exec -it -e DISPLAY=${DISPLAY} --user ${uname} ${container_name} /bin/bash

exec:
	docker exec -it -e DISPLAY=${DISPLAY} --user ${uname} ${container_name} /bin/bash
stop:
	-docker rm -f ${container_name}

_prep:
	mkdir -p ${top_dir}/dot-android ${top_dir}/dot-config ${top_dir}/sdk ${top_dir}/projects 
	xhost +
