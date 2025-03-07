FROM mysql:8.0

# Copy the SQL initialization file to the MySQL directory
COPY ./scripts/dbtest.sql /docker-entrypoint-initdb.d/

# Copy the custom MySQL configuration file
COPY ./confs/my.cnf /etc/mysql/conf.d/

# Adjust the permissions of the configuration file
RUN chmod 644 /etc/mysql/conf.d/my.cnf

# Expose the MySQL port
EXPOSE 3306