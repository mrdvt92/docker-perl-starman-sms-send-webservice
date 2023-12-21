#!/usr/bin/perl
use strict;
use warnings;
use Plack::Builder qw{builder enable};
require Plack::Middleware::Favicon_Simple;
require SMS::Send::Adapter::Node::Red;

my $app = SMS::Send::Adapter::Node::Red->psgi_app;

builder {
  enable "Plack::Middleware::Favicon_Simple";
  $app;
};
