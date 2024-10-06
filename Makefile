# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pollivie <pollivie.student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/10/06 10:07:31 by pollivie          #+#    #+#              #
#    Updated: 2024/10/06 10:07:31 by pollivie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DATA_DIR_MARIADB = /home/pollivie/data/mariadb
DATA_DIR_WORDPRESS = /home/pollivie/data/wordpress
DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml
ENV_FILE = ./srcs/.env

all: check-env create-dirs
	docker compose -f $(DOCKER_COMPOSE_FILE) build
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

check-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "Error: .env file not found in ./srcs directory"; \
		exit 1; \
	fi

create-dirs:
	mkdir -p $(DATA_DIR_MARIADB)
	mkdir -p $(DATA_DIR_WORDPRESS)
	sudo chown -R $(whoami):$(whoami) $(DATA_DIR_MARIADB)
	chmod -R 755 $(DATA_DIR_MARIADB)

logs:
	docker compose -f $(DOCKER_COMPOSE_FILE) logs

clean:
	docker container stop nginx mariadb wordpress || true

fclean: clean
	@sudo rm -rf $(DATA_DIR_MARIADB)/*
	@sudo rm -rf $(DATA_DIR_WORDPRESS)/*
	@docker system prune -af

re: fclean all

.PHONY: all check-env create-dirs logs clean fclean re
