use 5.026;
use lib qw/lib/;
use Mojolicious::Lite;

use Delogger::DB;
use Delogger::Log;

plugin Config => { file => 'conf.conf' };
my $DB  = Delogger::DB->new(db_file => app->config('db_file'));
my $LOG = Delogger::Log->new;

get '/#chan/#date' => sub {};
get '/#chan/#date/#id' => sub {
    my $self = shift;

    # set error info and simply bail before redirect if we need
    # to show it to the user.
    $self->stash(info =>
        'Could not find log hash for the given URL. Note: no new logs are'
        . ' being added. Only historical data exists'
    );

    my $info = $DB->by_id( substr $self->stash('id'), 2 )
        or return;
    my $to = $self->redirect_to($LOG->find(%$info))
        or return;
    $self->redirect_to($to);
};

app->start;

# https://irclog.perlgeek.de/perl6/2018-05-23#i_16195729
# https://irclog.perlgeek.de/perl6/2018-05-23/i_16195729
