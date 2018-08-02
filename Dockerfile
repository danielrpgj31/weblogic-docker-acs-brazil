# LICENSE CDDL 1.0 + GPL 2.0
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for WebLogic 12c (Full) Generic Distribution
# 
# IMPORTANT
# ---------
# You can go into 'samples/12.1.3-generic-domain' after building the generic raw image
# and build that image, for example:
# 
#   $ cd samples/12c-generic-domain
#   $ sudo docker build -t mywls .
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) fmw_12.1.3.0_wls.jar
#     Download the Generic installer from http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-main-097127.html
#
# (2) jdk-8u181-linux-x64.rpm
#     Download from http://www.oracle.com/technetwork/java/javase/downloads/
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ sudo docker build -t oracle/weblogic:12.1.3 . 
#
# Pull base image
# ---------------
FROM oraclelinux:7

# Maintainer
# ----------
MAINTAINER Daniel Ribeiro Junior <daniel.r.junior@oracle.com>

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV JAVA_RPM jdk-8u181-linux-x64.rpm
ENV WLS_PKG fmw_12.1.3.0_wls.jar
ENV JAVA_HOME /usr/java/default
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom

# Setup required packages (unzip), filesystem, and oracle user
# ------------------------------------------------------------
RUN mkdir /u01 && \
    chmod a+xr /u01 && \
    useradd -b /u01 -m -s /bin/bash oracle 

# Copy packages
COPY ./installers/$WLS_PKG /u01/
COPY ./installers/$JAVA_RPM /u01/
COPY ./installers/silent.rsp /u01/
COPY ./installers/oraInst.loc /u01/

# Install and configure Oracle JDK 8u25
# -------------------------------------
RUN rpm -i /u01/$JAVA_RPM && \ 
    rm /u01/$JAVA_RPM

# Change the open file limits in /etc/security/limits.conf
RUN sed -i '/.*EOF/d' /etc/security/limits.conf && \
    echo "* soft nofile 16384" >> /etc/security/limits.conf && \ 
    echo "* hard nofile 16384" >> /etc/security/limits.conf && \ 
    echo "# EOF"  >> /etc/security/limits.conf

# Change the kernel parameters that need changing.
RUN echo "net.core.rmem_max=4192608" > /u01/oracle/.sysctl.conf && \
    echo "net.core.wmem_max=4192608" >> /u01/oracle/.sysctl.conf && \ 
    sysctl -e -p /u01/oracle/.sysctl.conf

# Adjust file permissions, go to /u01 as user 'oracle' to proceed with WLS installation
RUN chown oracle:oracle -R /u01
WORKDIR /u01
USER oracle

# Installation of WebLogic 
RUN mkdir /u01/oracle/.inventory
RUN java -jar $WLS_PKG -ignoreSysPrereqs -novalidation -silent -responseFile /u01/silent.rsp -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME && \
    rm $WLS_PKG /u01/oraInst.loc /u01/silent.rsp

WORKDIR /u01/oracle/

ENV PATH $PATH:/u01/oracle/weblogic/oracle_common/common/bin

# Define default command to start bash. 
CMD ["bash"]
