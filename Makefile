DB_URI="postgres:postgres@localhost/app"

PROJECT_NAME="postgraphile-playground"

DOCKER_DB_FILE=docker/postgres/Dockerfile
DOCKER_DB_TAG=local/$(PROJECT_NAME)-db:latest

PWD=$(shell pwd)
DOCKER_COMPOSE_DIR="docker"


print-%: ; @echo $*=$($*)
guard-%:
	@test ${${*}} || (echo "FAILED! Environment variable $* not set " && exit 1)
	@echo "-> use env var $* = ${${*}}";

.PHONY : help
help : Makefile
	@sed -n 's/^##//p' $<

### docker db ###

## db.build   : build db docker image
db.build:
	@echo "build start: DB --> docker-tag $(DOCKER_DB_TAG)"
	docker build -t $(DOCKER_DB_TAG) -f $(DOCKER_DB_FILE) .
	@echo "build complete: DB --> docker-tag $(DOCKER_DB_TAG)"

##### docker-compose (common) #####

## docker-compose.up   : stack up
docker-compose.up: guard-DOCKER_COMPOSE_CONCERN
	docker-compose -f $(DOCKER_COMPOSE_DIR)/docker-compose-$(DOCKER_COMPOSE_CONCERN).yml up
## docker-compose.down   : stack down
docker-compose.down:
	docker-compose -f $(DOCKER_COMPOSE_DIR)/docker-compose-$(DOCKER_COMPOSE_CONCERN).yml down
## docker-compose.down.v   : stack down and remove volumes
docker-compose.down.v:
	docker-compose -f $(DOCKER_COMPOSE_DIR)/docker-compose-$(DOCKER_COMPOSE_CONCERN).yml down -v



## db-local.up   : build and start compose stack "db-local"
db-local.up: db.build
	make db-local.start
## db-local.start   : start compose stack "db-local"
db-local.start:
	make docker-compose.up DOCKER_COMPOSE_CONCERN=db-local
## db-local.down   : stop compose stack "db-local"
db-local.down:
	make docker-compose.down DOCKER_COMPOSE_CONCERN=db-local
## db-local.down.v   : stop compose stack "db-local" and remove volumes
db-local.down.v:
	make docker-compose.down.v DOCKER_COMPOSE_CONCERN=db-local



## postgraphile.up
postgraphile.up:
	$(eval DEBUG := "postgraphile:graphql,postgraphile:request,postgraphile:postgres*")
	npx postgraphile -c postgres://$(DB_URI) --enhance-graphiql --extended-errors severity,code,detail,hint,positon,internalPosition,internalQuery,where,schema,table,column,dataType,constraint,file,line,routine


