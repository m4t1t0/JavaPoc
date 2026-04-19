IMAGE := javapoc
PORT  := 8080

.PHONY: help dev debug watch test build run up stop shell logs clean rebuild

help:
	@echo "Local dev (fast hot-reload, needs local JDK 25):"
	@echo "  make dev      - run the app locally with Spring Boot DevTools"
	@echo "  make debug    - run the app in JDWP debug mode on port 5005"
	@echo "  make watch    - (second terminal) recompile on file change"
	@echo "  make test     - run tests"
	@echo ""
	@echo "Docker (prod-like):"
	@echo "  make build    - build the Docker image"
	@echo "  make run      - run the container on port $(PORT) (foreground)"
	@echo "  make up       - run the container detached"
	@echo "  make stop     - stop the detached container"
	@echo "  make logs     - tail logs of the detached container"
	@echo "  make shell    - open a shell inside a running container"
	@echo "  make clean    - remove the image"
	@echo "  make rebuild  - clean + build (no cache)"

dev:
	./gradlew bootRun

debug:
	./gradlew bootRun --debug-jvm

watch:
	./gradlew build --continuous -x test

test:
	./gradlew test

build:
	docker build -t $(IMAGE) .

run:
	docker run --rm -p $(PORT):8080 --name $(IMAGE) $(IMAGE)

up:
	docker run -d --rm -p $(PORT):8080 --name $(IMAGE) $(IMAGE)

stop:
	-docker stop $(IMAGE)

logs:
	docker logs -f $(IMAGE)

shell:
	docker exec -it $(IMAGE) sh

clean:
	-docker rmi $(IMAGE)

rebuild:
	docker build --no-cache -t $(IMAGE) .
