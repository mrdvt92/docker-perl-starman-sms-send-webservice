FROM almalinux:9

RUN yum -y install epel-release && yum clean all
RUN yum -y install https://linux.davisnetworks.com/el9/updates/mrdvt92-release-8-3.el9.mrdvt92.noarch.rpm && yum clean all

#PSGI Server
RUN yum -y install perl-Starman perl-SMS-Send perl-Sys-Path && yum clean all

#App dependacies
RUN yum -y install perl-Plack perl-Plack-Middleware-Method_Allow perl-Plack-Middleware-Favicon_Simple perl-SMS-Send-Adapter-Node-Red perl-CGI-PSGI perl-CGI-Widgets && yum clean all

#SMS Driver to match your INI Configuration
RUN yum -y install perl-SMS-Send-VoIP-MS && yum clean all

#Install PSGI Application into /app/ folder
COPY ./app.psgi        /app/
COPY ./images/logo.png /app/images/
COPY ./*SMS-Send.ini   /etc/
RUN if [ -e /etc/private-SMS-Send.ini ] ; then cp /etc/private-SMS-Send.ini /etc/SMS-Send.ini; fi

#Expose Starman web server on port 5027
EXPOSE 5027

HEALTHCHECK --interval=1m --timeout=2s CMD curl -LSfs http://127.0.0.1:5027/favicon.ico || exit 1

#Command to start app
WORKDIR /app
CMD ["/usr/bin/starman", "--workers", "4", "--port", "5027", "app.psgi"]
