# Makefile

up:
	docker compose up -d

down:
	docker compose down

shell:
	docker exec -it centos7_container /bin/bash

rebuild:
	docker compose down
	docker compose up --build -d

logs:
	docker compose logs -f

clean:
	docker compose down -v
