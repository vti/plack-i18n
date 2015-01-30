package Plack::I18N::Util;

use strict;
use warnings;

use parent 'Exporter';

our @EXPORT_OK = qw(try_load_class);

use Plack::Util ();

sub try_load_class {
    my ($class) = @_;

    my $path = (join '/', split /::/, $class) . '.pm';

    return $class if exists $INC{$path} && defined $INC{$path};

    {
        no strict 'refs';
        for (keys %{"$class\::"}) {
            return $class if defined &{"$class\::$_"};
        }
    }

    eval {
        Plack::Util::load_class($class);
    } || do {
        my $e = $@;

        die $e unless $@ =~ m/Can't locate $path in \@INC/;

        return;
    };
}

1;
