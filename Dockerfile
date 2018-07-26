FROM ubuntu:bionic
RUN apt-get update && apt-get install -y --no-install-recommends nodejs \
    postgresql \
    npm \
    ruby
RUN apt-get install -y --no-install-recommends ruby-dev
RUN apt-get install -y --no-install-recommends  build-essential
RUN apt-get install -y --no-install-recommends  libpq-dev
RUN gem install bundler
ADD . /foxhound
RUN cd /foxhound && bundle && npm install
EXPOSE 4567
WORKDIR /foxhound
CMD rackup -p 4567
