FROM postgres:11

LABEL maintainer "onisuly <onisuly@gmail.com>"

RUN apt-get update && \
    apt-get --fix-missing -y --force-yes --no-install-recommends install git ca-certificates && \
    git clone https://github.com/tada/pljava.git && \
    apt-get --fix-missing -y --force-yes --no-install-recommends install g++ maven && \
    apt-get --fix-missing -y --force-yes --no-install-recommends install postgresql-server-dev-11 libpq-dev && \
    apt-get --fix-missing -y --force-yes --no-install-recommends install libecpg-dev libkrb5-dev && \
    apt-get --fix-missing -y --force-yes --no-install-recommends install openjdk-8-jdk libssl-dev && \
    export PGXS=/usr/lib/postgresql/11/lib/pgxs/src/makefiles/pgxs.mk && \
    cd pljava && \
    git checkout tags/V1_5_7 && \
    mvn clean install && \
    java -jar $(ls /pljava/pljava-packaging/target/pljava-pg11*.jar) && \
    mkdir /pljava-examples && \
    cp /pljava/pljava-examples/target/pljava-examples-1.5.7.jar /pljava-examples/pljava-examples.jar && \
    cd ../ && \
    apt-get -y remove --purge --auto-remove git ca-certificates g++ maven postgresql-server-dev-11 libpq-dev libecpg-dev openjdk-8-jdk libkrb5-dev libssl-dev && \
    apt-get --fix-missing -y --force-yes --no-install-recommends install openjdk-8-jdk-headless && \
    apt-get -y clean autoclean autoremove && \
    rm -rf ~/.m2 /pljava /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
