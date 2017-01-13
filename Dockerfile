FROM ruby:2.4
MAINTAINER palkan_tula@mail.ru

RUN apt-get update && apt-get install -y build-essential
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

RUN apt-get install -y nodejs

RUN npm install -g phantomjs

RUN mkdir -p /app 
WORKDIR /app

ENV LANG C.UTF-8
ENV BUNDLE_PATH /bundle
ENV BUNDLE_BIN /bundle/bin
ENV PATH /bundle/bin:$PATH

RUN gem install bundler

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]

CMD ["rails", "server", "-b", "0.0.0.0"]
