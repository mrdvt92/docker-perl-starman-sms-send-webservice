FROM almalinux:8

RUN yum -y install epel-release
RUN yum -y update
RUN crb enable
RUN yum -y install perl-Plack
RUN yum -y install /usr/bin/cpanm
RUN yum -y install perl-Test-Exception
RUN yum -y install perl-List-MoreUtils
RUN yum -y install perl-Test-Differences
RUN yum -y install perl-Capture-Tiny
RUN yum -y install perl-File-Slurp
RUN yum -y install perl-libwww-perl
RUN yum -y install perl-LWP-Protocol-https

RUN yum -y install https://repo.openfusion.net/el-8-x86_64/openfusion-release-0.8-2.of.el8.noarch.rpm

RUN yum -y install perl-IO-Stringy
#RUN yum -y install perl-JSON-Util
#RUN yum -y install perl-IO-Any
RUN yum -y install perl-IO-String
#RUN yum -y install perl-Sys-Path

RUN cpanm install Sys::Path

#RUN yum -y install perl-Module-Build-Tiny
#RUN yum -y install perl-ExtUtils-InstallPaths
#RUN yum -y install perl-Net-Server
#RUN yum -y install perl-Test-TCP
#RUN yum -y install perl-Test-Requires

RUN yum -y install perl-Starman
#RUN yum -y install perl-Class-Adapter
RUN yum -y install perl-Module-Pluggable

RUN cpanm install SMS::Send

RUN yum -y install perl-CGI
RUN yum -y install perl-URI
RUN yum -y install perl-JSON-XS
RUN yum -y install perl-Config-IniFiles
RUN yum -y install perl-Path-Class
RUN yum -y install perl-Devel-Hide
RUN yum -y install perl-JSON

RUN cpanm install SMS::Send::Adapter::Node::Red #0.08
RUN cpanm install Plack::Middleware::Favicon_Simple
RUN cpanm install Plack::Middleware::Method_Allow
RUN cpanm install SMS::Send::VoIP::MS

RUN cpanm install HTML::Tiny

#Install PSGI Application into /app/ folder
COPY ./app.psgi /app/
COPY ./SMS-Send.ini /etc/

#Expose Starman web server on port 5027
EXPOSE 5027

HEALTHCHECK --interval=1m --timeout=2s CMD curl -LSfs http://127.0.0.1:5027/favicon.ico || exit 1

#Command to start app
CMD ["/usr/bin/starman", "--workers", "4", "--port", "5027", "/app/app.psgi"]
