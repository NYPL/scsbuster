FROM phusion/passenger-ruby33 AS production

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
RUN mkdir -p /etc/my_init.d
# ADD ./provisioning/docker_build/startup_scripts/01_db_migrate.sh /etc/my_init.d/01_db_migrate.sh
CMD ["/sbin/my_init"]

EXPOSE 80
RUN apt-get update
# https://github.com/phusion/passenger-docker/issues/195
RUN apt-get install -y tzdata

# So nginx won't clear the environment variables (see notes in environment-variables.conf)
ADD ./provisioning/docker_build/environment-variables.conf /etc/nginx/main.d/environment-variables.conf

# Passenger Configuration & App
RUN rm /etc/nginx/sites-enabled/default
ADD ./provisioning/docker_build/scsbuster.conf /etc/nginx/sites-enabled/scsbuster.conf
# Needed to chown /tmp/cache
COPY --chown=app:app . /home/app/scsbuster

## Bundle Gems
WORKDIR /home/app/scsbuster
COPY Gemfile /home/app/scsbuster
COPY Gemfile.lock /home/app/scsbuster
RUN gem update --system
RUN bundle install --without test development
RUN RAILS_ENV=production bundle exec rake assets:precompile
RUN chown -R app:app /home/app/scsbuster/tmp/cache

# Enables ngnix+passenger
RUN rm -f /etc/service/nginx/down

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM production AS development

RUN cd /home/app/scsbuster && bundle --with test development
