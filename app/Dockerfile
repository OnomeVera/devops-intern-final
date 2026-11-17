
FROM nginx:1.27-alpine

ARG BUILD_SHA=local

LABEL maintainer="Onome Oviero"
LABEL application="devops-intern-final"

RUN mkdir -p /tmp/client_temp \
    /tmp/proxy_temp \
    /tmp/fastcgi_temp \
    /tmp/uwsgi_temp \
    /tmp/scgi_temp \
    && chown -R 101:101 /tmp \
    && chown -R 101:101 /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

COPY index.html /usr/share/nginx/html/index.html

RUN sed -i "s/BUILD_ID_PLACEHOLDER/${BUILD_SHA}/g" \
    /usr/share/nginx/html/index.html

USER 101:101

EXPOSE 8080

HEALTHCHECK --interval=30s \
    --timeout=3s \
    --start-period=5s \
    --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1:8080/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]
