#!perl6

use v6;

use Test;
use HTTP::UserAgent;
use Test::Util::ServerPort;

my $port = get-unused-port();

use lib $*PROGRAM.parent.child('lib').Str;

use TestServer;

%*ENV<NO_PROXY> = 'localhost';

my $test-server = test-server(my $done-promise = Promise.new, :$port);
LEAVE { 'Shutting down server.'.say; $done-promise.keep("shutdown"); };
my $ua          = HTTP::UserAgent.new;

plan 2;

ok $ua.post("http://localhost:$port/rSeeOther", {}).is-success,
  '303 redirect does GET';

for <once> { # Tests for version 2.0 - default behavior changed for 302
unless %*ENV<AUTHOR_TESTING> {
  diag "AUTHOR_TESTING was not set";
  skip-rest("AUTHOR_TESTING was not set");
  last;
}
ok try $ua.post("http://localhost:$port/rFound", {}).is-success,
  '302 redirect does GET by default';

} # author tests
# vim: expandtab shiftwidth=4 ft=perl6
