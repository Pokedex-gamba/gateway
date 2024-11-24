run:
	docker compose up -d

stop:
	docker compose stop

rerun: stop run

down:
	docker compose down

redeploy: down run

clean:
	docker image ls | grep '<none>' | awk '{ print $$3 }' | xargs docker image rm

nuke:
	docker compose down -v

nuke-run: nuke run

update-git:
	git pull
	git submodule update --init --recursive

update-containers:
	docker compose pull --ignore-buildable
	docker compose build

update-all: update-git update-containers
