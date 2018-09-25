#Create the Base Image
FROM ubuntu:16.04

MAINTAINER Manimaran <manimaran.r@sysfore.com>

# prepare for install
RUN apt-get update

# install dependencies
RUN apt-get install -y --no-install-recommends \
		curl \
		wget \
		build-essential \
		zlib1g-dev \
		libpcre3 \
		libpcre3-dev
		
# define the desired versions
ENV NGINX_VERSION nginx-1.13.1

# path to download location
ENV NGINX_SOURCE http://nginx.org/download/

# build path
ENV BPATH /usr/src

# download source packages and signatures
RUN cd $BPATH \
	&& wget $NGINX_SOURCE$NGINX_VERSION.tar.gz \
	&& wget $NGINX_SOURCE$NGINX_VERSION.tar.gz.asc
	
# verify and and extract
RUN cd $BPATH \
	&& tar xzf $NGINX_VERSION.tar.gz \
	&& rm *.tar.gz*

# build and install nginx
RUN cd $BPATH/$NGINX_VERSION && ./configure \
	--sbin-path=/usr/sbin/nginx \
	--conf-path=/etc/nginx/nginx.conf \
	--pid-path=/var/run/nginx.pid \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	&& make && make install \
	&& { \
		echo; \
		echo 'daemon off;'; \
	   } >> /etc/nginx/nginx.conf
	   
# webserver root directory
#WORKDIR /usr/share/nginx/html

#COPY nginx.conf /etc/nginx/nginx.conf
#COPY nginx.conf.default /etc/nginx/nginx.conf.default

# Expose ports.
EXPOSE 80

# Define default command.
CMD ["nginx"]