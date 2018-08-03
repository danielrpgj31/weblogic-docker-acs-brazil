#
# Script to deploy an application using WLST offline API 
#
# Since: August, 2018
# Author: daniel.r.junior@oracle.com
#
# =============================
import os
import random
import string
import socket

# Domain path 
domain_path = '/u01/oracle/weblogic/user_projects/domains/base_domain'

# Read Domain
readDomain(domain_path)

# Create application
cd('/')
app = create('shoppingcart', 'AppDeployment')
app.setSourcePath('/u01/oracle/shoppingcart.war')
app.setStagingMode('nostage')

# Assign application to cluster
assign('AppDeployment', 'shoppingcart', 'Target', 'AdminServer')

# Update domain. Close It. Exit
updateDomain()
closeDomain()
exit()
