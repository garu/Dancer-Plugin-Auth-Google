use strict;
use warnings;
use Test::More import => ['!pass'];
plan tests => 4;

{
    use Dancer;
    use Dancer::Plugin::Auth::Google;

    setting( plugins => {
        'Auth::Google' => {
            client_id        => 1234,
            client_secret    => 4321,
            callback_url     => 'http://myserver:3000/auth/google/callback',
            callback_success => '/ok',
            callback_fail    => '/not-ok',
            scope            => 'plus.login',
        },
    });

    ok auth_google_init(), 'able to load auth_google_init()';

    my $auth_url = 'https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=1234&redirect_uri=http%3A%2F%2Fmyserver%3A3000%2Fauth%2Fgoogle%2Fcallback&scope=plus.login&access_type=online';

    is auth_google_authenticate_url() => $auth_url,
       'auth_google_authenticate_url() returns the proper facebook_auth_url';

    is auth_google_authenticate_url( additional => 'plus' ) 
        => $auth_url . '&additional=plus',
       'auth_google_authenticate_url() can take additional parameters';
}

use Dancer::Test;

route_exists [ GET => '/auth/google/callback' ], 'google auth callback route exists';


