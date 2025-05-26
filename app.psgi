#!/usr/bin/perl
use strict;
use warnings;
use Plack::Builder qw{builder enable mount};
use Plack::Middleware::Static;
use Plack::Middleware::Method_Allow;
use Plack::Middleware::Favicon_Simple;
use SMS::Send;
use SMS::Send::Adapter::Node::Red 0.10;
use CGI::PSGI;
use CGI::Widgets;

my $adapter = SMS::Send::Adapter::Node::Red->new;

sub myroot {
  my $title    = 'SMS::Send Adapter for Node-Red';
  my $env      = shift;
  my $cgi      = CGI::PSGI->new($env);
  my $html     = CGI::Widgets->new(cgi=>$cgi, title=>$title);
  my $function = $cgi->param('function') || '';
  my $driver   = $adapter->driver;
  my @errors   = ();
  my $sent     = 0;
  my $to;
  my $text;
  if ($function) {
    $to   = $cgi->param('to')   || '';
    $text = $cgi->param('text') || '';
    push @errors, 'Error: field "to" required'   unless $to;
    push @errors, 'Error: field "text" required' unless $text;
    unless (@errors) {
      $adapter->{'input'} = {to=>$to, text=>$text};
      $sent               = $adapter->send_sms;
      push @errors, $adapter->error;
    }
  }
  $html->push(
    $html->form(
      $html->frame("SMS",
        ($sent   ? $html->cgi->p(qq{Status: Sent, To: $to, Text: "$text"}) : ()),
        (@errors ? $html->cgi->p(\@errors)                                 : ()),
        $html->table(
          [ "SMS Driver", $adapter->driver               ],
          [ "To",         $cgi->textfield(-name=>'to')   ],
          [ "Text",       $cgi->textfield(-name=>'text') ],
        ),
        $cgi->submit(-name=>'function', -value=>'Send!'),
      ),
    ),
  );
  return [ $cgi->psgi_header, [ $html->content ] ];
}

builder {
  enable 'Plack::Middleware::Method_Allow', allow=>['GET', 'POST'];
  enable 'Plack::Middleware::Favicon_Simple';
  enable 'Plack::Middleware::Static', path => 'images';
  mount '/sms' => $adapter->psgi_app; #JSON API
  mount '/'    => \&myroot;           #GET/POST HTML form API
};
