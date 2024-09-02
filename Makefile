DC_FILE := srcs/docker-compose.yml

ensure-dirs:
	@mkdir -p /home/rpambhar/data /home/rpambhar/data/mariadb /home/rpambhar/data/wordpress

up: ensure-dirs
	@echo "Building and starting all containers..."
	@docker compose -f $(DC_FILE) up --build -d

down:
	@echo "Stopping and removing all containers..."
	@docker compose -f $(DC_FILE) down

stop:
	@echo "Stopping containers..."
	@docker compose -f $(DC_FILE) stop

start: ensure-dirs
	@echo "Starting containers..."
	@docker compose -f $(DC_FILE) start

status:
	@echo "Showing status of containers..."
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

clean: clean-containers clean-images clean-volumes

clean-containers:
	@echo "Stopping and removing all containers..."
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true

clean-images:
	@echo "Removing all images..."
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true

clean-volumes:
	@echo "Removing all volumes..."
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

fclean: down clean
	@echo "Performing system-wide cleanup of Docker resources..."
	@docker system prune -f

reset: fclean
	@echo "Resetting project data..."
	@rm -rf /home/rpambhar/data/mariadb /home/rpambhar/data/wordpress
	@mkdir /home/rpambhar/data/mariadb /home/rpambhar/data/wordpress

help:
	@echo "Available targets:"
	@echo "  up            - Build and start all containers"
	@echo "  down          - Stop and remove all containers"
	@echo "  start         - Start all stopped containers"
	@echo "  stop          - Stop all running containers"
	@echo "  status        - Show status of containers"
	@echo "  clean         - Remove containers, images, and volumes"
	@echo "  clean-images  - Remove all Docker images"
	@echo "  clean-volumes - Remove all Docker volumes"
	@echo "  fclean        - Clean all containers, images, and volumes then prune system"
	@echo "  reset         - Reset the entire project and data"

.PHONY: up down stop start status clean clean-images clean-volumes fclean reset help ensure-dirs
