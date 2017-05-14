FROM phusion/passenger-ruby24:0.9.20

ENV HOME /root

CMD ["/sbin/my_init"]

# Set the default Ruby version for app
RUN bash -lc 'rvm get head --auto-dotfiles'
RUN bash -lc 'rvm install ruby-2.4.1'
RUN bash -lc 'rvm --default use ruby-2.4.1'
RUN bash -lc 'gem install bundle'

# Build the bundle before adding app, to cache bundle in Docker image
COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bash -lc 'rvm-exec 2.4.1 bundle install --jobs 8'

# Enable Nginx and Passenger
RUN rm -f /etc/service/nginx/down

RUN rm /etc/nginx/sites-enabled/default
ADD nginx.conf /etc/nginx/sites-enabled/webapp.conf

# Set environment variables for app in each Passenger instance
ADD docker-env.conf /etc/nginx/main.d/docker-env.conf

# Copy app and setup
RUN mkdir /home/app/webapp

COPY . /home/app/webapp
COPY script/docker/rails-init /usr/local/bin/rails-init

RUN chown -R app:app /home/app/webapp \
 && chmod +x /usr/local/bin/rails-init

WORKDIR /home/app/webapp

RUN touch log/production.log
RUN chmod 0664 log/production.log

# Make sure all app is owned by user "app"
RUN chown -R app:app ./

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
