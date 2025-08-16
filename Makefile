all:
	docker build -t brightdev:latest --no-cache --output type=docker .

run:
	docker run --rm -it -v "$(pwd):/workspace" brightdev  bash

install:
	cp brightdev ~/bin

clear:
	docker builder prune
