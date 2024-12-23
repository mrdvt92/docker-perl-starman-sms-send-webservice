#!/usr/bin/perl
use strict;
use warnings;
use Plack::Builder qw{builder enable mount};
use HTML::Tiny;
use Plack::Middleware::Method_Allow;
use Plack::Middleware::Favicon_Simple;
use SMS::Send::Adapter::Node::Red 0.08;

my $sms    = SMS::Send::Adapter::Node::Red->psgi_app;
my $driver = $ENV{'SMS_SEND_ADAPTER_NODE_RED_DRIVER'};

builder {
  enable 'Plack::Middleware::Method_Allow', allow=>['GET', 'POST'];
  enable 'Plack::Middleware::Favicon_Simple';
  mount '/sms' => $sms;
  mount '/'    => sub {[200 => ['Content-Type' => 'text/plain'] => ["SMS Driver: $driver"]]};
};
