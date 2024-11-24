NAME = inception
USER = afaqir

all: setup up

setup:
	@sudo mkdir -p /home/$(USER)/data/wordpress
	@sudo mkdir -p /home/$(USER)/data/mariadb
	@sudo chmod 777 /home/$(USER)/data/wordpress
	@sudo chmod 777 /home/$(USER)/data/mariadb

up:
	@docker-compose -f srcs/docker-compose.yml up --build

down:
	@docker-compose -f srcs/docker-compose.yml down

clean: down
	@docker system prune -a

fclean: clean
	@sudo rm -rf /home/$(USER)/data/wordpress/*
	@sudo rm -rf /home/$(USER)/data/mariadb/*
	@docker volume rm $$(docker volume ls -q)

re: fclean all

.PHONY: all setup up down clean fclean re
