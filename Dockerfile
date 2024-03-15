# Resmi MySQL imajını temel al
FROM mysql:8.0.36-debian
# "vi" editörünü yükle
RUN apt-get update && apt-get install -y vim
COPY backup-zip.sh /bin/
RUN chmod +x  /bin/backup-zip.sh

# MySQL servisini başlat
CMD ["mysqld"]
