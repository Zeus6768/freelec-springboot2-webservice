#!/bin/bash

REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=freelec-springboot2-webservice

echo "> Copy build file"

cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> Check working application PID"

CURRENT_PID=$(pgrep -fl freelec-springboot2-webservice | grep jar | awk '{print $1}')

echo "> Working application PID: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
  echo "> No working application."
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

echo "> Deploy new application"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> Add execute permission to $JAR_NAME"

chmod +x $JAR_NAME

echo "> Run $JAR_NAME"

nohup java -jar \
    -Dspring.config.location=/home/ec2-user/app/application-oauth.properties,classpath:/application-real.properties,/home/ec2-user/app/application-real-db.properties \
    -Dspring.profiles.active=real \
    $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &