.PHONY: build
build:
	docker build -t jpalumickas/csgo-server .

.PHONY: push
push: build
	docker push jpalumickas/csgo-server
