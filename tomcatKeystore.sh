#!/bin/bash

# Original: https://github.com/macadmins/docker-jss/blob/master/tomcatKeystore.sh

keypass=changeit
CN=casper.localhost.ssl
OU=Development
O=MyOrg
L=Helsinki
ST=Helsinki
C=FI
numDays=365

/usr/bin/keytool -genkey -alias tomcat -keyalg RSA -keypass $keypass -storepass $keypass -dname "CN=$CN, OU=$OU, O=$O, L=$L, ST=$ST, C=$C" -keystore /usr/local/tomcat/conf/.keystore -validity $numDays
