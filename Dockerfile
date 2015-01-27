FROM phusion/passenger-full:0.9.14

MAINTAINER james@jameseggers.com

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# activate nginx
RUN rm -f /etc/service/nginx/down

# configure nginx
ADD docker_conf/nginx_pro.conf /etc/nginx/sites-enabled/pro.conf
ADD docker_conf/nginx_env.conf /etc/nginx/main.d/nginx_env.conf

# updates
RUN apt-get update && apt-get -qy upgrade

RUN apt-get update && apt-get install -qy openjdk-7-jdk

RUN apt-get -qy install locales

RUN apt-get -qy install wget

# Configure timezone and locale
RUN echo "Europe/Dublin" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata
RUN export LANGUAGE=en_US.UTF-8; export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; locale-gen en_US.UTF-8; DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# workdir
WORKDIR /home/app/sailing

# gems
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock

RUN bundle install

# add app
ADD . /home/app/sailing
