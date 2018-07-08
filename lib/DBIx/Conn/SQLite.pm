package DBIx::Conn::SQLite;

# DATE
# VERSION

use strict;
use warnings;

sub import {
    require DBI;

    my $pkg  = shift;

    my $dsn;
    die "import(): Please supply at least a database name" unless @_;
    if ($_[0] =~ /=/) {
        $dsn = "DBI:SQLite:".shift;
    } else {
        $dsn = "DBI:SQLite:dbname=".shift;
    }

    my $var = 'dbh';
    if (@_ && $_[0] =~ /\A\$(\w+)\z/) {
        $var = $1;
        shift;
    }

    my $dbh = DBI->connect($dsn, "", "");

    my $caller = caller();
    {
        no strict 'refs';
        no warnings 'once';
        *{"$caller\::$var"} = \$dbh;
    }
}

1;
# ABSTRACT: Shortcut to connect to SQLite database

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

In the command-line, instead of saying:

 % perl -MDBI -E'my $dbh = DBI->connect("dbi:SQLite:dbname=mydb", "", ""); $dbh->selectrow_array("query"); ...'

or:

you can just say:

 % perl -MDBIx::Conn::SQLite=mydb -E'$dbh->selectrow_array("query"); ...'

To change the exported database variable name from the default '$dbh'

 % perl -MDBIx::Conn::SQLite=mydb,'$handle' -E'$handle->selectrow_array("query"); ...'

To supply connection attributes:

 % perl -MDBIx::Conn::SQLite=mydb,RaiseError,1 -E'$dbh->selectrow_array("query"); ...'


=head1 DESCRIPTION

This module offers some saving in typing when connecting to a SQLite database
using L<DBI>, and is particularly handy in one-liners. It automatically
C<connect()> and exports the database handle C<$dbh> for you.

You often only have to specify the database name in the import argument:

 -MDBIx::Conn::SQLite=mydb

This will result in the following DSN:

 DBI:SQLite:dbname=mydb

If you want to use another variable name other than the default C<$dbh> for the
database handle, you can specify this in the second import argument (note the
quoting because otherwise the shell will substitute with shell variable):

 -MDBIx::Conn::SQLite=mydb,'$handle'

Lastly, if you want to supply connection attributes, you can do so in the third
argument and the rest (or second and the rest, if you don't customize database
handle name):

 -MDBIx::Conn::SQLite=mydb,RaiseError,1


=head1 SEE ALSO

L<DBIx::Conn::MySQL>

L<DBIx::Conn::Pg>
