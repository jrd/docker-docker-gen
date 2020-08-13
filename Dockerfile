FROM coderedcorp/docker-gen:0.7.5-cr1
RUN apk update && apk upgrade
COPY ./docker-gen-wrapper /usr/local/bin/docker-gen-wrapper
ENTRYPOINT ["/usr/local/bin/docker-gen-wrapper"]
CMD ["-notify-sighup", "nginx-proxy", "-watch", "-wait", "5s:30s", "/etc/docker-gen/templates/nginx.tmpl", "/etc/nginx/conf.d/default.conf"]
