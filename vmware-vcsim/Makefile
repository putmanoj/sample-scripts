
# Include the .env file if it exists
-include .env
export

TEST_SERVER_BASE_URL ?= ${HTTPS_PROXY_BASE_URL}
DEFAULT_SLEEP ?= 2s

# REFERER_HEADER ?= -H "Referer: https://ibm.com"

MAKEFLAGS += --no-print-directory

default: run

certs:
	./makefile-helper.sh certs

# non-detached mode
run: certs vcsim-data/saved-state
	docker compose up --force-recreate --remove-orphans
	@$(MAKE) stop

# detached mode: start containers in the background
start: certs vcsim-data/saved-state
	docker compose up -d --remove-orphans

# remove containers running in the background
stop: vcsim-data-save
	docker compose down

ps:
	docker compose ps

logs:
	docker compose logs -f

sleep2s:
	sleep ${DEFAULT_SLEEP}

restart:
	@echo "Restarting..."
	@$(MAKE) stop
	sleep ${DEFAULT_SLEEP}
	@$(MAKE) start
	sleep ${DEFAULT_SLEEP}
	@$(MAKE) ps

# Static HTML Route
index:
	curl -k -L ${REFERER_HEADER} ${TEST_SERVER_BASE_URL}

# Route to VMware Simulator Endpoints
vcsim-sdk:
	curl -k -L ${REFERER_HEADER} --post301 -X POST ${TEST_SERVER_BASE_URL}/sdk \
		-H "Content-Type: text/xml" \
		-H "SOAPAction: urn:vim25/6.0" \
		-d '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><RetrieveServiceContent xmlns="urn:vim25"><_this type="ServiceInstance">ServiceInstance</_this></RetrieveServiceContent></soapenv:Body></soapenv:Envelope>' \
		| xmllint --format -

vcsim-logs:
	docker compose logs -f vcsim-service

# if vcsim-data/saved-state not exists, then copy vcsim-data/base-state
vcsim-data/saved-state:
	$(MAKE) vcsim-data/base-state
	cp -r ./vcsim-data/base-state ./vcsim-data/saved-state

# create create-base-vcsim-data vcsim-service startup
vcsim-data/base-state:
	./makefile-helper.sh create-base-vcsim-data

# save current data from vcsim-service
vcsim-data-save:
	./makefile-helper.sh save-vcsim-data
