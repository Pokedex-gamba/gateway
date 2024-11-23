run:
	docker compose up -d

stop:
	docker compose down

rerun: stop run

clean:
	docker compose down -v

run-clean: clean run

update-git:
	git pull
	git submodule update --init --recursive

update-containers:
	docker compose pull
	docker compose build

update-all: update-git update-containers
