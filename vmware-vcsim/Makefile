TEST_SERVER_HOST ?= localhost
DEFAULT_SLEEP ?= 2s

MAKEFLAGS += --no-print-directory

default: run

certs:
	mkdir ./certs && \
	openssl req -x509 -newkey rsa:2048 -nodes -keyout ./certs/server.key -out ./certs/server.crt -days 365 -subj "/CN=127.0.0.1" -addext "subjectAltName = IP:127.0.0.1"

run: certs
	docker compose up --remove-orphans

start: certs
	docker compose up -d --remove-orphans

stop:
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
	curl -k ${REFERER_HEADER} https://${TEST_SERVER_HOST}

# Route to VMware Simulator Endpoints
vcsim-sdk:
	curl -k ${REFERER_HEADER} -X POST https://${TEST_SERVER_HOST}/sdk \
		-H "Content-Type: text/xml" \
		-H "SOAPAction: urn:vim25/6.0" \
		-d '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><RetrieveServiceContent xmlns="urn:vim25"><_this type="ServiceInstance">ServiceInstance</_this></RetrieveServiceContent></soapenv:Body></soapenv:Envelope>' \
		| xmllint --format -

vcsim-logs:
	docker compose logs -f vcsim-service