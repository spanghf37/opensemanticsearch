FROM debian:latest

RUN apt-get update && apt-get upgrade && apt-get install -y build-essential git wget curl systemd sudo && curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && apt-get -y install nodejs

RUN curl -sL https://repos.influxdata.com/influxdb.key | apt-key add - \
  source /etc/os-release \
  echo "deb https://repos.influxdata.com/debian stretch stable" | tee /etc/apt/sources.list.d/influxdb.list

RUN apt-get update && apt-get install influxdb

COPY influxdb.conf /etc/influxdb/influxdb.conf

EXPOSE 8086

VOLUME /var/lib/influxdb

COPY entrypoint.sh /entrypoint.sh
COPY init-influxdb.sh /init-influxdb.sh

RUN chmod +x /entrypoint.sh && chmod +x /init-influxdb.sh

RUN mkdir /home/gun-test

COPY index.js /home/gun-test/index.js
COPY influxtest.js /home/gun-test/influxtest.js

WORKDIR /home/gun-test

RUN npm install gun gun-flint influx && git clone https://github.com/spanghf37/gun-influxdb.git && ls

ENTRYPOINT ["/entrypoint.sh"]
CMD ["influxd"]
