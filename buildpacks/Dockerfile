FROM jekyll/jekyll

MAINTAINER Nicholas Page

RUN mkdir -p /srv/jekyll

COPY . /srv/jekyll

WORKDIR /srv/jekyll

RUN bundle

EXPOSE 9001
