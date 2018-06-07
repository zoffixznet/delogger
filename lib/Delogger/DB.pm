package Delogger::DB;

use Mojo::Base -base;
use Mojo::SQLite;

has db_file => 'hashes.sqlite.db';
has db => sub {
    my $self = shift;
    my $make_db = ! -e $self->db_file;
    my $db = Mojo::SQLite->new('sqlite:' . $self->db_file);
    $make_db and $db->db->query('
        CREATE TABLE hashes (
            channel TEXT NOT NULL,
            date    TEXT NOT NULL,
            id      TEXT NOT NULL,
            hash    TEXT NOT NULL
        );
    ');
    $db;
};


sub add {
    my ($self, %data) = @_;
    $self->db->db->delete(hashes => { %data{id} });
    $self->db->db->insert(hashes => { %data{qw/channel  date  id  hash/} });
}

sub by_id {
    my ($self, $id) = @_;
    $self->db->db->select(hashes => undef, { id => $id })->hashes->first
}

1;

__END__
