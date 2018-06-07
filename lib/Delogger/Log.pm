package Delogger::Log;

use Mojo::Base -base;
use Mojo::UserAgent;
use Encode qw/encode_utf8/;
use Digest::SHA qw/sha1_hex/;
use constant SITE => 'http://colabti.org/irclogger/irclogger_log/';

sub find {
    my ($self, %info) = @_;

    my $url = SITE . substr($info{channel}, 1) . "?date=$info{date}";
    my $res = Mojo::UserAgent->new(max_redirects => 10)->get($url)->result;
    unless ($res->is_success) {
        say $res->message;
        return;
    }

    chomp(my $hash = $info{hash});
    for ($res->dom->find('tr.talk')->each) {
        return $url . '#' . $_->at('.time')->{id}
            if $hash eq sha1_hex encode_utf8 $_->at('.message')->all_text;
    }
}

1;

__END__
