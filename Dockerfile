# Resmi MySQL imajını temel al
FROM mysql:8.0.36-debian
# "vi" editörünü yükle
RUN apt-get update && apt-get install -y vim percona-toolkit lsb-release wget curl sysbench \ 
    && wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb \
    && dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb 
RUN apt-get update && apt-get install -y percona-xtrabackup-80 
RUN apt-get update && apt-get install qpress -y

COPY backup-zip.sh backup-w-mx.sh /bin/
RUN chmod +x  /bin/backup-w-mx.sh \
    && chmod +x  /bin/backup-zip.sh  
    

# MySQL servisini başlat
CMD ["mysqld"]
