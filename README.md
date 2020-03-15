# Developer Traefik

This project let you start a Traefik container to serve projects in a development enviroment

## Installation

First run the `certificate.sh` script to generate a new self-signed certificate. You can install it into your local certificate database. It's not mandatory, buy you can avoid the self-signed warning messages in your browsers.

## Routes

In Linux all hosts like `*.localhost` are resolved as localhost. The certificate is signed to `*.developer.localhost` hostnames.

## Dashboard

Traefik dashboard is enabled by default in unsecure mode. You can open the dashboard in this direction https://traefik.developer.localhost/dashboard/

## Docker container configuration

Please read the official documentation. This is a example of a docker-compose file.

    version: '3'

    services:
        service_name:
            image: ...
            labels:
            # By default docker routing must be enabled 
            - "traefik.enable=true"
            # Route this service with this host. service_name must be unique
            - "traefik.http.routers.service_name.rule=Host(`host.developer.localhost`)"
            # This lines activate HTTPS. Don't touch
            - "traefik.http.routers.service_name.entrypoints=web-secure"
            - "traefik.http.routers.service_name.tls=true"
            # Optionals
            # Traefik get the EXPOSE route in the container. If you don't have or have many
            # configure the real port
            # - "traefik.http.services.service_name.loadbalancer.server.port=8080"
            # By default EXPOSE or internal port is configured like http
            # Uncomment this if it is using https
            # - "traefik.http.services.service_name.loadbalancer.server.protocol=https"
            # If there are more than one service in one container you must named it
            # - "traefik.http.routers.service_name.service=service_name"

`service_name` is a tag to identify the service. Must be unique in all containers.

