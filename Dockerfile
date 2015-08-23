FROM alpine:latest
MAINTAINER Hellyna NG <hellyna@hellyna.com>

ADD run /root/run
RUN /root/run

ENV PATH="/usr/local/openresty/nginx/sbin:${PATH}"
EXPOSE 80/tcp 443/tcp
CMD ["nginx", "-g", "daemon off;"]
