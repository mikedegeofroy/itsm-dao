up-debian:
	docker compose up -d debian11

up-centos:
	docker compose up -d centos7

run-centos: # for correct working NetworkManager
	docker run --rm --privileged  -ti -e container=docker  -v /sys/fs/cgroup:/sys/fs/cgroup  itsm-dao-centos7 /usr/sbin/init

down:
	docker compose down

shell-debian:
	docker exec -it debian11_container /bin/bash

shell-centos:
	docker exec -it centos7_container /bin/bash

rebuild-debian:
	docker compose down debian11
	docker compose up --build -d debian11

rebuild-centos:
	docker compose down centos7
	docker compose up --build -d centos7

logs:
	docker compose logs -f

clean:
	docker compose down -v
