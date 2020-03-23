# Counter-Strike: Global Offensive Server Docker

## Usage

```sh
docker run -p 27015:27015 -p 27015:27015/udp jpalumickas/csgo-server -console -usercon +game_type 0 +game_mode 1 +mapgroup mg_active + map de_dust2 +rcon_password test
```

## Development

Build image

```sh
make build
```

Push image

```sh
make push
```
