FROM debian:latest

ENV TIKA_VERSION 1.19
ENV TIKA_SERVER_URL https://www.apache.org/dist/tika/tika-server-$TIKA_VERSION.jar

RUN	apt-get update \
	&& apt-get install gnupg openjdk-8-jre-headless curl gdal-bin tesseract-ocr \
		tesseract-ocr-eng tesseract-ocr-ita tesseract-ocr-fra tesseract-ocr-spa tesseract-ocr-deu -y \
	&& curl -sSL https://people.apache.org/keys/group/tika.asc -o /tmp/tika.asc \
	&& gpg --import /tmp/tika.asc \
	&& curl -sSL "$TIKA_SERVER_URL.asc" -o /tmp/tika-server-${TIKA_VERSION}.jar.asc \
	&& NEAREST_TIKA_SERVER_URL=$(curl -sSL http://www.apache.org/dyn/closer.cgi/${TIKA_SERVER_URL#https://www.apache.org/dist/}\?asjson\=1 \
		| awk '/"path_info": / { pi=$2; }; /"preferred":/ { pref=$2; }; END { print pref " " pi; };' \
		| sed -r -e 's/^"//; s/",$//; s/" "//') \
	&& echo "Nearest mirror: $NEAREST_TIKA_SERVER_URL" \
	&& curl -sSL "$NEAREST_TIKA_SERVER_URL" -o /tika-server-${TIKA_VERSION}.jar \
	&& apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get upgrade && apt-get install -y wget default-jre-headless libjs-jquery curl apache2 libapache2-mod-php php php-xml php-bcmath libapache2-mod-wsgi-py3 python3-django python3-pycurl python3-rdflib python3-rdflib python3-requests python3-pysolr python3-dateutil python3-lxml python3-feedparser poppler-utils pst-utils daemon python3-pyinotify python3-celery python3-nltk python3-pip python3-dev python3-falcon python3-gunicorn build-essential libssl-dev libffi-dev rabbitmq-server scantailor tesseract-ocr tesseract-ocr-all hunspell-de-de-frami hunspell-hu

RUN mkdir /home/opensemanticsearch

WORKDIR /home/opensemanticsearch && apt-get -f install

RUN wget https://opensemanticsearch.org/download/open-semantic-search_18.09.27.deb

RUN java -jar /tika-server-${TIKA_VERSION}.jar -h 0.0.0.0 && dpkg --install open-semantic-search_18.09.27.deb && apt-get -f install

EXPOSE 80
EXPOSE 8983
EXPOSE 9998
