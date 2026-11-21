FROM debian:bookworm

ARG DOMAIN_NAME

RUN apt-get update \
 && apt-get install -y --no-install-recommends nginx openssl \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/nginx/sites-enabled/default /var/www/html/*

# Self-signed TLS certificate for our domain
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/inception.key \
        -out /etc/ssl/certs/inception.crt \
        -subj "/CN=${DOMAIN_NAME}"

COPY conf/inception.conf /etc/nginx/conf.d/inception.conf
RUN sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/" /etc/nginx/conf.d/inception.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
