FROM ubuntu:bionic
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nodejs \
    postgresql-client \
    npm \
    ruby \
    ruby-dev \
    build-essential \
    libpq-dev
RUN gem install bundler
ADD . /foxhound
WORKDIR /foxhound
RUN bundle && npm install
EXPOSE 4567
CMD rackup -o 0.0.0.0 -p 4567
