FROM debian:latest

RUN apt-get update && apt-get upgrade && apt-get install -y wget default-jre-headless libjs-jquery curl apache2 libapache2-mod-php php php-xml php-bcmath libapache2-mod-wsgi-py3 python3-django python3-pycurl python3-rdflib python3-rdflib python3-requests python3-pysolr python3-dateutil python3-lxml python3-feedparser poppler-utils pst-utils daemon python3-pyinotify python3-celery python3-nltk python3-pip python3-dev python3-falcon python3-gunicorn build-essential libssl-dev libffi-dev rabbitmq-server scantailor tesseract-ocr tesseract-ocr-all hunspell-de-de-frami hunspell-hu

RUN mkdir /home/opensemanticsearch

WORKDIR /home/opensemanticsearch && apt-get -f install

RUN wget https://opensemanticsearch.org/download/open-semantic-search_18.09.27.deb

RUN dpkg --install open-semantic-search_18.09.27.deb && apt-get -f install

EXPOSE 80
