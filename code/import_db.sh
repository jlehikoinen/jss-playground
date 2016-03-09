#!/bin/sh

# Import MySQL db to Docker container

echo "Waiting for the MySQL container to start up.."
sleep 20

echo "Importing db.."
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" \
      -P"$MYSQL_PORT_3306_TCP_PORT" \
      -uroot \
      -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" \
      "$MYSQL_ENV_MYSQL_DATABASE" \
      < /tmp/"$IMPORT_DATABASE"

exit $?
