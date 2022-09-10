# Openvpn Docker
To build from scratch:

Using docker compose. Before start, create a `.env` file with your public ip address:
```.env
HOST_ADDR=10.12.13.14
```

Or simply use the command below:
```shell
echo "HOST_ADDR=$(curl -s https://api.ipify.org)" > .env
```
Then build the image
```shell
docker-compose build
```

To build using docker command:

```shell
docker build . -t openvpn
```

## Start the docker after building
Using docker compose:

```shell
docker-compose up -d
```

Start using docker command:

```shell
docker run -it -d --cap-add=NET_ADMIN -p 1194:1194/udp -p 8080:8080/tcp -e HOST_ADDR=$(curl -s https://api.ipify.org) -v $PWD/ovpnfiles:/openvpn/data --name openvpn openvpn
```

# Note:
By default, the docker image will generate one clinet, the ovpn file can be download using command, the ovpn file can be found in the reflected directory `ovpnfiles/` on the host machine

```shell
docker exec -d openvpn wget -O /openvpn/data/client.ovpn localhost:8080
```

To generate more client and generate more client files, use the command below first and then use the command above to download the new ovpn file.

```shell
docker exec -d openvpn ./genclient.sh
```

**Modified from repository [dockovpn](https://github.com/dockovpn/dockovpn)**
