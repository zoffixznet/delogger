
use lib qw/lib/;
use strict;
use warnings;
use 5.026;
use Delogger::DB;

#@ARGV == 4 or die "Usage: $0 hashes.txt channel date id";
# my ($file, $chan, $date, $id) = @ARGV;
# open my $fh, '<', $file or die "failed to open file `$file`: $!";
# my $data = do { undef $/; <$fh> };

# $data =~ /^\Q$chan $date $id (\S+) $/xm;

@ARGV == 2 or die "Usage: $0 sqlite.db hashes.txt";
my ($db_file, $hashes_file) = @ARGV;
my $db = Delogger::DB->new(db_file => $db_file);

open my $fh, '<', $hashes_file or die "Failed to open `$hashes_file`: $!";

my $row = 0;
while (defined(my $line = readline $fh)) {
    my ($channel, $date, $id, $hash) = split ' ', $line, 4;
    $db->add(
        channel => $channel,
        date    => $date,
        id      => $id,
        hash    => $hash,
    );
    $row++;
    unless ($row % 1000) {
        say "Added row $row";
    }
}


