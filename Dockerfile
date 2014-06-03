FROM debian:jessie

RUN apt-get update && apt-get install -y \
		build-essential \
		libgd2-dev \
		libgeoip-dev \
		libpcre3-dev \
		libssl-dev \
		libxslt1-dev

ADD . /usr/src/nginx
WORKDIR /usr/src/nginx

RUN ./configure \
		--user=www-data \
		--group=www-data \
		--prefix=/usr/local/nginx \
		--conf-path=/etc/nginx.conf \
		--http-log-path=/proc/self/fd/1 \
		--error-log-path=/proc/self/fd/2 \
		--with-http_addition_module \
		--with-http_auth_request_module \
		--with-http_dav_module \
		--with-http_geoip_module \
		--with-http_gzip_static_module \
		--with-http_image_filter_module \
		--with-http_realip_module \
		--with-http_spdy_module \
		--with-http_ssl_module \
		--with-http_stub_status_module \
		--with-http_sub_module \
		--with-http_xslt_module \
		--with-ipv6 \
		--with-mail \
		--with-mail_ssl_module \
		--with-pcre-jit

RUN make -j"$(nproc)"
RUN make install \
	&& ln -vs ../nginx/sbin/nginx /usr/local/sbin/ \
	&& chown -R www-data:www-data /usr/local/nginx

RUN { \
		echo; \
		echo '# stay in the foreground so Docker has a process to track'; \
		echo 'daemon off;'; \
	} >> /etc/nginx.conf

WORKDIR /usr/local/nginx/html

EXPOSE 80
CMD ["nginx"]
