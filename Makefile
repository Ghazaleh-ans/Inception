COMPOSE   = docker compose -f srcs/docker-compose.yml
DATA_PATH = $(HOME)/data

all: up

up:
	mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --rmi all

fclean:
	$(COMPOSE) down --volumes --rmi all
	sudo rm -rf $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress

re: fclean all

.PHONY: all up down clean fclean re
