FROM almalinux:8

RUN yum -y install epel-release
RUN yum -y update
RUN crb enable

RUN yum -y install https://repo.openfusion.net/el-8-x86_64/openfusion-release-0.8-2.of.el8.noarch.rpm
RUN yum -y install https://linux.davisnetworks.com/el8/updates/mrdvt92-release-8-3.el8.noarch.rpm

#PSGI Server
RUN yum -y install perl-Starman

#SMS
RUN yum -y install perl-SMS-Send
RUN yum -y install perl-SMS-Send-VoIP-MS
RUN yum -y install perl-Sys-Path

#App dependacies
RUN yum -y install perl-Plack
RUN yum -y install perl-Plack-Middleware-Method_Allow
RUN yum -y install perl-Plack-Middleware-Favicon_Simple
RUN yum -y install perl-SMS-Send-Adapter-Node-Red

#Install PSGI Application into /app/ folder
COPY ./app.psgi /app/
COPY ./SMS-Send.ini /etc/

#Expose Starman web server on port 5027
EXPOSE 5027

HEALTHCHECK --interval=1m --timeout=2s CMD curl -LSfs http://127.0.0.1:5027/favicon.ico || exit 1

#Command to start app
CMD ["/usr/bin/starman", "--workers", "4", "--port", "5027", "/app/app.psgi"]
