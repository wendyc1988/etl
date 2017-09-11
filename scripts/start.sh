#!/bin/bash

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`"/$link"
    fi
done

die ( ) {
    echo
    echo "$*"
    echo
    exit 1
}

APP_HOME="`pwd -P`"
JDBC_PROPERTIES="${APP_HOME}/simple-jndi/jdbc.properties"

SRC_SERVER=${SRC_SERVER}
SRC_DATABASE=${SRC_DATABASE}
SRC_PORT=${SRC_PORT}
SRC_USERNAME=${SRC_USERNAME}
SRC_PASSWORD=${SRC_PASSWORD}

DEST_SERVER=${DEST_SERVER}
DEST_DATABASE=${DEST_DATABASE}
DEST_PORT=${DEST_PORT}
DEST_USERNAME=${DEST_USERNAME}
DEST_PASSWORD=${DEST_PASSWORD}

TIME_OUT=${TIME_OUT:=15}

${APP_HOME}/wait-for-it.sh -h ${SRC_SERVER} -p ${SRC_PORT} -t ${TIME_OUT}
if [ $? -ne 0 ];then
die "ERROR:can not connect ${SRC_SERVER}:${SRC_PORT}
Please check the URL and port is correct"
fi

${APP_HOME}/wait-for-it.sh -h ${DEST_SERVER} -p ${DEST_PORT} -t ${TIME_OUT}
if [ $? -ne 0 ];then
die "ERROR:can not connect ${DEST_SERVER}:${DEST_PORT}
Please check the URL and port is correct"
fi

COMMAND=${COMMAND:=/application/data-integration/kitchen.sh -file=product/product.kjb > /dev/null}
SCHEDULE=${SCHEDULE:=0 30 20 * *}
exec go-cron -s "$SCHEDULE" -- /bin/bash -c "${COMMAND}" 
