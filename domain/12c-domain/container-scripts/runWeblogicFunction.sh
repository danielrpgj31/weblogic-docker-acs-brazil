#!/bin/bash

# Run Weblogic EJB Embedded 
java -classpath /u01/oracle/weblogic/wlserver/server/lib/weblogic.jar:/u01/oracle/classes     buttso.demo.weblogic.ejbembedded.PingPongClient &> runWeblogicFunction.out

echo "Function return(ok)"

# Start Weblogic AdminServer
#echo "Starting Node Manager..." && \
#/u01/oracle/weblogic/user_projects/domains/base_domain/bin/startNodeManager.sh &> nm.out && \
#echo "Node Manager initialized"

