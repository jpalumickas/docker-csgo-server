FROM ubuntu:18.04
MAINTAINER Justas Palumickas <jpalumickas@gmail.com>

ENV TERM xterm

ENV USER steam
ENV STEAM_DIR /home/$USER
ENV STEAMCMD_DIR $STEAM_DIR/steamcmd
ENV SERVER_DIR $STEAM_DIR/csgo-server

ARG STEAMCMD_URL=http://media.steampowered.com/client/steamcmd_linux.tar.gz

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends --no-install-suggests \
    lib32gcc1 curl net-tools lib32stdc++6 locales ca-certificates \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && adduser --disabled-password --gecos "" $USER \
    && mkdir $STEAMCMD_DIR \
    && mkdir $SERVER_DIR \
    && curl $STEAMCMD_URL | tar -C $STEAMCMD_DIR -xvz \
    && mkdir -p $STEAM_DIR/.steam/sdk32 \
    && chown -R $USER:$USER $STEAM_DIR \
    && chown -R $USER:$USER $SERVER_DIR \
    && ln -s $STEAMCMD_DIR/linux32/steamclient.so $STEAM_DIR/.steam/sdk32/steamclient.so

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

USER $USER

COPY --chown=steam:steam csgo_update.txt $STEAM_DIR/csgo_update.txt
COPY --chown=steam:steam steam_appid.txt $SERVER_DIR/steam_appid.txt
COPY --chown=steam:steam run.sh $STEAM_DIR/run.sh

# EXPOSE 27015 27015/udp 27005/udp 27020 27020/udp

WORKDIR $SERVER_DIR
ENTRYPOINT exec ${STEAM_DIR}/run.sh
