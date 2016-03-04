FROM tomcat:7.0.59-jre7

MAINTAINER Nick McSpadden <nmcspadden@gmail.com>

RUN rm -rf /usr/local/tomcat/webapps/*
ADD ROOT.war /usr/local/tomcat/webapps/ROOT.war
ADD tomcatKeystore.sh /home/docker/jss/tomcatKeystore.sh
RUN bash /home/docker/jss/tomcatKeystore.sh
RUN mkdir -p /home/docker/jss/logs && mkdir -p /Library/JSS/ && ln -s /home/docker/jss/logs /Library/JSS/Logs
ADD server.xml /usr/local/tomcat/conf/server.xml
RUN mv /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/US_export_policy.jar /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/US_export_policy.ORIG.jar && mv /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/local_policy.jar /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/local_policy.ORIG.jar
ADD US_export_policy.jar /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/US_export_policy.jar
ADD local_policy.jar /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/local_policy.jar

EXPOSE 8443

