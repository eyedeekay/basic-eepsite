
build: build-i2pd build-darkhttpd

run: i2pd darkhttpd

build-i2pd:
	docker build --rm -f Dockerfile.i2pd -t eyedeekay/eepsite-i2pd .

run-i2pd: network
	docker run --restart=always -i -d -t \
		--name eepsite-i2pd \
		--network eepsite \
		--network-alias eepsite-i2pd \
		--hostname eepsite-i2pd \
		--ip 172.81.81.2 \
		-p :4567 \
		-p 127.0.0.1:7070:7070 \
		-v eepsite:/var/lib/i2pd \
		eyedeekay/eepsite-i2pd; true

i2pd: build-i2pd run-i2pd

build-darkhttpd:
	docker build --rm \
		--build-arg WEBSITE=website \
		-f Dockerfile.darkhttpd -t eyedeekay/eepsite-darkhttpd .

run-darkhttpd: network
	docker run --restart=always -i -t -d \
		--name eepsite-darkhttpd \
		--network eepsite \
		--network-alias eepsite-darkhttpd \
		--hostname eepsite-darkhttpd \
		--ip 172.81.81.3 \
		eyedeekay/eepsite-darkhttpd

darkhttpd: build-darkhttpd run-darkhttpd

network:
	docker network create --subnet 172.81.81.0/29 eepsite; true

site:
	markdown README.md > website/index.html
