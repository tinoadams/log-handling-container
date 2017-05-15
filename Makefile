build:
	docker build -t filebeat .

start: stop
	docker run -d --name filebeat \
		--net elk -e ELASTICSEARCH_URL="es:9200" \
		-h filebeat \
		filebeat

stop:
	docker rm -f filebeat || echo "skip..."

logs:
	docker logs -f filebeat

debug:
	docker exec -ti filebeat bash

test: start
	sleep 3

	curl http://localhost:8000 | grep 'HHVM Version 3.19.2' > /dev/null
	ssh -o BatchMode=yes -vvv root@localhost -p 2222 2>&1 | grep 'Authentications that can continue' > /dev/null

	docker rm -f filebeat
