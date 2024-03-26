Backup and Test Script with Docker MySQL
This project includes scripts and configurations for setting up a Dockerized MySQL database, generating test data, and taking backups using different methods.

Dockerfile
The Dockerfile provided in this project sets up a MySQL database container with additional tools installed for backup purposes.

Installs necessary packages and tools such as vim, percona-toolkit, sysbench, etc.
Installs Percona XtraBackup for efficient backups.
Installs the qpress compression tool.
Copies backup scripts into the container.
Sets execute permissions for the backup scripts.
Defines the command to start the MySQL service when the container starts.
Backup Script (backup-w-mx.sh)
This script automates the process of generating test data, taking backups using mysqldump and xtrabackup, and compressing the backup files.

Requires two parameters: <DB_USER> and <DB_PASSWORD> for MySQL connection.
Creates a new database named testdb.
Prepares the testdb with test data using sysbench.
Takes a backup of the database using mysqldump.
Takes a compressed backup of the database using xtrabackup.
Outputs success or failure messages accordingly.
YAML Workflow File
The YAML workflow file automates the process of building the Docker image, running the MySQL container, executing the backup script inside the container, and cleaning up Docker resources.

Listens for pushes to any branch in the repository.
Builds the Docker image using the provided Dockerfile.
Runs a MySQL container with the built image.
Waits for MySQL to start before executing the backup script.
Cleans up Docker resources after the backup process completes.
Usage
Clone this repository.
Modify the backup-w-mx.sh script if necessary, especially the backup directory.
Ensure Docker is installed on your system.
Run the provided YAML workflow file in your CI/CD environment.
Check the backup files in the specified directory after the workflow completes.
Note
Ensure that sensitive information such as passwords is handled securely, especially in production environments.
Customize the scripts and configurations according to your specific requirements.
