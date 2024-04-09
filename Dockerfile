# Base image - using the official MySQL image version 8.0.36-debian
FROM mysql:8.0.36-debian

# Install necessary packages and tools
RUN apt-get update && apt-get install -y vim percona-toolkit lsb-release wget curl sysbench \ 
    && wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb \
    && dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb 

# Install Percona XtraBackup 8.0
RUN apt-get update && apt-get install -y percona-xtrabackup-80 

# Install qpress compression tool
RUN apt-get update && apt-get install qpress -y

# Copy backup scripts to the /bin directory inside the container
COPY backup-zip.sh backup.sh /bin/

# Set execute permissions for backup scripts
RUN chmod +x  /bin/backup.sh \
    && chmod +x  /bin/backup-zip.sh  

# Command to start MySQL service when the container starts
CMD ["mysqld"]
