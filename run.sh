#!/usr/bin/env bash

set -e

# These envvars should've been set by the Dockerfile
# If they're not set then something went wrong during the build
: "${STEAM_DIR:?'ERROR: STEAM_DIR IS NOT SET!'}"
: "${STEAMCMD_DIR:?'ERROR: STEAMCMD_DIR IS NOT SET!'}"
: "${SERVER_DIR:?'ERROR: SERVER_DIR IS NOT SET!'}"

export SERVER_HOSTNAME="${SERVER_HOSTNAME:-Counter-Strike: Global Offensive Dedicated Server}"
export SERVER_PASSWORD="${SERVER_PASSWORD:-}"
export RCON_PASSWORD="${RCON_PASSWORD:-changeme}"
export STEAM_ACCOUNT="${STEAM_ACCOUNT:-changeme}"
export AUTHKEY="${AUTHKEY:-changeme}"
export IP="${IP:-0.0.0.0}"
export PORT="${PORT:-27015}"
export TV_PORT="${TV_PORT:-27020}"
export TICKRATE="${TICKRATE:-128}"
export FPS_MAX="${FPS_MAX:-300}"
export GAME_TYPE="${GAME_TYPE:-0}"
export GAME_MODE="${GAME_MODE:-1}"
export MAP="${MAP:-de_dust2}"
export MAPGROUP="${MAPGROUP:-mg_active}"
export MAXPLAYERS="${MAXPLAYERS:-12}"
export TV_ENABLE="${TV_ENABLE:-1}"
export LAN="${LAN:-0}"
export SOURCEMOD_ADMINS="${SOURCEMOD_ADMINS:-}"
export RETAKES="${RETAKES:-0}"

echo "Updating server5"

# Attempt to update CSGO before starting the server
# "$STEAMCMD_DIR/steamcmd.sh" +runscript "$STEAM_DIR/csgo_update.txt"


echo "Adding config files"
# Create dynamic autoexec config
cat << AUTOEXECCFG > "$SERVER_DIR/csgo/cfg/autoexec.cfg"
log on
hostname "$SERVER_HOSTNAME"
rcon_password "$RCON_PASSWORD"
sv_password "$SERVER_PASSWORD"
sv_cheats 0
exec banned_user.cfg
exec banned_ip.cfg
AUTOEXECCFG

# Create dynamic server config
cat << SERVERCFG > "$SERVER_DIR/csgo/cfg/server.cfg"
tv_enable $TV_ENABLE
tv_delaymapchange 1
tv_delay 30
tv_deltacache 2
tv_dispatchmode 1
tv_maxclients 10
tv_maxrate 0
tv_overridemaster 0
tv_relayvoice 1
tv_snapshotrate 64
tv_timeout 60
tv_transmitall 1
writeid
writeip
SERVERCFG

# Start the server
exec "$BASH" "$SERVER_DIR/srcds_run" \
        -console \
        -usercon \
        -game csgo \
        -autoupdate \
        -authkey "$AUTHKEY" \
        -steam_dir "$STEAMCMD_DIR" \
        -steamcmd_script "$STEAM_DIR/csgo_update.txt" \
        -tickrate "$TICKRATE" \
        -port "$PORT" \
        -maxplayers_override "$MAXPLAYERS" \
        +fps_max "$FPS_MAX" \
        +game_type "$GAME_TYPE" \
        +game_mode "$GAME_MODE" \
        +mapgroup "$MAPGROUP" \
        +map "$MAP" \
        +sv_setsteamaccount "$STEAM_ACCOUNT" \
        +tv_port "$TV_PORT" \
        +ip 0.0.0.0 \
        +net_public_adr 0.0.0.0 \
        +clientport 27015 \
        +sv_lan 1
