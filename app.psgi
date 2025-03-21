#!/usr/bin/perl
use strict;
use warnings;
use Plack::Builder qw{builder enable mount};
use Plack::Middleware::Method_Allow;
use Plack::Middleware::Favicon_Simple;
use SMS::Send::Adapter::Node::Red 0.10;
use CGI::PSGI;

my $adapter = SMS::Send::Adapter::Node::Red->new;


sub myroot {
  my $title   = 'SMS::Send Adapter for Node-Red';
  my $env     = shift;
  my $q       = CGI::PSGI->new($env);
  my $content = join "",
     $q->start_html(-title    => $title,
                    -bgcolor  => "#FFFFFF",
                    -encoding => ""),
     $q->p(sprintf('SMS Driver: %s', $adapter->driver)),
     $q->end_html;
  return [ $q->psgi_header, [ $content ] ];
}

builder {
  enable 'Plack::Middleware::Method_Allow', allow=>['GET', 'POST'];
  enable 'Plack::Middleware::Favicon_Simple';
  mount '/sms' => $adapter->psgi_app;
  #mount '/'   => sub {[200 => ['Content-Type' => 'text/plain'] => [sprintf('SMS Driver: %s', $adapter->driver)]]};
  mount '/'    => \&myroot;
};

