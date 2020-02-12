FROM ubuntu:18.04
MAINTAINER Justas Palumickas <jpalumickas@gmail.com>

ENV USER csgo
ENV HOME /home/$USER
ENV SERVER $HOME/csgo-server

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install lib32gcc1 curl net-tools lib32stdc++6 locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && useradd $USER \
    && mkdir $HOME \
    && mkdir $HOME/steamcmd \
    && chown -R $USER:$USER $HOME \
    && mkdir $SERVER

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

COPY csgo_update.txt $SERVER/csgo_update.txt
COPY steam_appid.txt $SERVER/steam_appid.txt

RUN chown -R $USER:$USER $SERVER

USER $USER
RUN curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $HOME/steamcmd -xvz \
    && mkdir -p $HOME/.steam/sdk32 \
    && chown -R $USER:$USER $HOME/.steam \
    && ln -s $HOME/steamcmd/linux32/steamclient.so $HOME/.steam/sdk32/steamclient.so \
    && $HOME/steamcmd/steamcmd.sh +runscript $SERVER/csgo_update.txt

COPY run.sh $SERVER/run.sh

ENV SRCDS_RCON_PASSWORD=my-super-password

EXPOSE 27015 27015/udp 27005/udp 27020/udp

WORKDIR $SERVER
ENTRYPOINT ["./run.sh"]
CMD ["-console" "-usercon" "+game_type" "0" "+game_mode" "1" "+mapgroup" "mg_active" "+map" "de_dust2", "+rcon_password", "$SRCDS_RCON_PASSWORD"]
