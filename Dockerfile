ARG base=debian:bookworm
FROM ${base}
ARG base

ENV DEBIAN_FRONTEND=noninteractive 
ARG ver_jdk=17
ARG extra_app

RUN apt update
RUN apt install -y curl git make wget screen bash-completion openssh-client tzdata unzip locales-all \
                   python3 python3-pip openjdk-${ver_jdk}-jdk ibus-mozc vim ${extra_app}
#RUN localectl set-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"

ARG ver_studio=2022.3.1.20
RUN (cd /tmp; \
     wget --progress=bar:force https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${ver_studio}/android-studio-${ver_studio}-linux.tar.gz -O android-studio.tgz ;\
     mkdir -p /opt/android-studio; \
     tar xvzf android-studio.tgz -C /opt ;\
    )

RUN dpkg --add-architecture i386
RUN apt update
RUN apt install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 adb fastboot

ARG uid=1000
ARG uname=android
RUN addgroup --system --gid ${uid} ${uname} ;\
    adduser  --system --gid ${uid} --uid ${uid} --shell /bin/bash --home /home/${uname} ${uname} ; \
    echo "${uname}:${uname}" | chpasswd; \
    echo "set mouse-=a" > /home/${uname}/.vimrc; \
    (cd /etc/skel; find . -type f -print | tar cf - -T - | tar xvf - -C/home/${uname} ) ;

RUN mkdir -p /home/${uname}/.android /home/${uname}/.config /home/${uname}/AndroidStudioProjects; \
    chown -R ${uname}:${uname} /opt/android-studio /home/${uname}

RUN rm -f /tmp/android-studio.tgz

VOLUME /home/${uname}/.android /home/${uname}/.config /home/${uname}/AndroidStudioProjects
ENV PATH=${PATH}:/opt/android-studio/bin
ENV JAVA_HOME=/usr/lib/jvm/java-${ver_jdk}-openjdk-amd64
ENV STUDIO_JDK=${JAVA_HOME}
ENV DEBIAN_FRONTEND=
#RUN dpkg --remove-architecture i386; apt update
USER ${uname}
WORKDIR /home/${uname}/AndroidStudioProjects
