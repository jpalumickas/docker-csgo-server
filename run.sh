#!/bin/sh

cd $HOME/csgo-server
./srcds_run -game csgo -tickrate 128 -autoupdate -steam_dir ~/home/csgo/steamcmd -steamcmd_script ~/home/csgo/csgo/csgo_update.txt $@
