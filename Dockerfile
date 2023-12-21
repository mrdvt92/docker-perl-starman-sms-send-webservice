FROM centos:7

ENV container docker

RUN echo "Install from CentOS and EPEL repos"
RUN yum -y install epel-release
RUN yum -y update
RUN yum -y install perl-Plack

RUN echo "Install Starman and Dependancies from OpenFusion RPM repo"
RUN yum -y install http://repo.openfusion.net/centos7-x86_64/openfusion-release-0.8-1.of.el7.noarch.rpm
RUN yum -y install perl-Starman --enablerepo=of

RUN echo "Install Plack Middleware from DavisNetworks RPM repo"
RUN yum -y install http://linux.davisnetworks.com/el7/updates/mrdvt92-release-8-3.el7.mrdvt92.noarch.rpm
RUN yum -y install 'perl(SMS::Send)'
RUN yum -y install 'perl(SMS::Send::Adapter::Node::Red)' #0.08
RUN yum -y install 'perl(Plack::Middleware::Favicon_Simple)'
RUN yum -y install 'perl(Sys::Path)' #add /etc to search path for INI file

#Install Particular SMS Drivers Here
RUN yum -y install 'perl(SMS::Send::VoIP::MS)'
#RUN yum -y install 'perl(SMS::Send::NANP::Twilio)'

#Install PSGI Application into /app/ folder
COPY ./app.psgi /app/
COPY ./SMS-Send.ini /etc/

#Expose Starman web server on port 5027
EXPOSE 5027

HEALTHCHECK --interval=1m --timeout=2s CMD curl -LSfs http://127.0.0.1:5027/favicon.ico || exit 1

#Command to start app
CMD ["/usr/bin/starman", "--workers", "4", "--port", "5027", "/app/app.psgi"]
