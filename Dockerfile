FROM debian:latest

RUN apt-get update && apt-get upgrade && apt-get install -y wget

RUN mkdir /home/opensemanticsearch

WORKDIR /home/opensemanticsearch

RUN wget https://opensemanticsearch.org/download/open-semantic-search_18.09.27.deb

RUN dpkg --install open-semanticsearch_18.09.27.deb

RUN apt-get -f install

EXPOSE 80
