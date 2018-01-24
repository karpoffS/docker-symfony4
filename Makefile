include .env

.DEFAULT_GOAL := help

MAKEFLAGS += --silent

###> symfony/framework-bundle ###
CONSOLE := $(shell which bin/console)
cache-clear:
ifdef CONSOLE
	@bin/console cache:clear --no-warmup --env=$(APP_ENV)
else
	@rm -rf var/cache/*
endif
.PHONY: cache-clear

cache-warmup: cache-clear
ifdef CONSOLE
	@bin/console cache:warmup --env=$(APP_ENV)
else
	@echo "Cannot warm up the cache (needs symfony/console).\n"
endif
.PHONY: cache-warmup
###< symfony/framework-bundle ###

# Makefile for Docker Nginx PHP Composer MySQL

# MySQL
MYSQL_DUMPS_DIR=var/dumps

help:
	@echo "\n"
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  clean               Clean directories for reset"
	@echo "  build               Build containers"
	@echo "  ps                  List running containers"
	@echo "  restart             Restart containers"
	@echo "  start               Start containers"
	@echo "  stop                Stop containers"
	@echo "  mysql-dump          Create backup of whole database"
	@echo "  mysql-restore       Restore backup from whole database"

clean:
	@rm -Rf data/db/mysql/*
	@rm -Rf $(MYSQL_DUMPS_DIR)/*

build:
	@docker-compose build

ps:
	@echo "\n"
	@docker-compose ps
	@echo "\n"

start:
	@echo "\n"
	@docker-compose up -d
	@echo "\n"
	@make ps
	@echo "\n"

stop:
	@echo "\n"
	@docker-compose down -v
	@echo "\n"

restart:
	@make stop
	@make start

mysql-dump:
	@echo "Start all databases in one dump file with location $(MYSQL_DUMPS_DIR)/db.sql\n"
	@mkdir -p $(MYSQL_DUMPS_DIR)
	@docker exec $(shell docker-compose ps -q mysqldb) mysqldump --all-databases -u"$(MYSQL_ROOT_USER)" -p"$(MYSQL_ROOT_PASSWORD)" > $(MYSQL_DUMPS_DIR)/db.sql 2>/dev/null

mysql-restore:
	@echo "Restore all databases with dump file\n"
	@docker exec -i $(shell docker-compose ps -q mysqldb) mysql -u"$(MYSQL_ROOT_USER)" -p"$(MYSQL_ROOT_PASSWORD)" < $(MYSQL_DUMPS_DIR)/db.sql 2>/dev/null

.PHONY: clean test code-sniff init
