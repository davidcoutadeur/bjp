package bjp;

BEGIN { $ENV{'DANCER_ENVIRONMENT'} = 'production' }

use Dancer2;
use GenerateBJP;
use Cwd 'abs_path';
my $script_path = abs_path($0);
$script_path =~ s/bin.*$//;
$script_path =~ s/\/$//; # remove trailing slash if any

our $VERSION = '1.0';

set port => "3000";


get '/' => sub {
    template 'index';
};

get '/hello/:name' => sub {
    return "Hi there " . params->{name};
};

any ['get'] => qr{^/bjp.*} => sub {
    my $uid = request->header('Auth-User');
    template 'bjp.tt', { uid => $uid };
};

any ['post'] => qr{^/bjp.*} => sub {
  my $post = request->params;
  my $file = &GenerateBJP::displayBJP($post, $script_path);

  return send_file(
        $script_path."/latex/bjp.pdf",
        content_type => 'application/pdf',
        filename => $file,
        system_path => 1
  );

};

true;
