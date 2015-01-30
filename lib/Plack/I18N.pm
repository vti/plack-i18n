package Plack::I18N;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Carp qw(croak);
use Locale::Maketext;
use Plack::Util ();
use Plack::I18N::Handle;

sub new {
    my $class = shift;
    my (%params) = @_;

    croak 'lexicon required'    unless $params{lexicon};

    my $self = {};
    bless $self, $class;

    $self->{i18n_class}       = $params{i18n_class} || __PACKAGE__ . '::Auto';
    $self->{locale_dir}       = $params{locale_dir};
    $self->{default_language} = $params{default_language} || 'en';

    $self->{lexicon} = $self->_build_lexicon(
        $params{lexicon},
        i18n_class       => $self->{i18n_class},
        locale_dir       => $self->{locale_dir},
        default_language => $self->{default_language}
    );

    $self->{languages} =
      $params{languages} || [sort $self->{lexicon}->detect_languages];

    return $self;
}

sub default_language {
    my $self = shift;

    return $self->{default_language};
}

sub languages {
    my $self = shift;

    return @{$self->{languages}};
}

sub handle {
    my $self = shift;
    my ($language) = @_;

    my $i18n_class = $self->{i18n_class};

    $self->{handles}->{$language} ||= do {
        my $handle = $i18n_class->get_handle($language);
        $handle->fail_with(sub { $_[1] });

        Plack::I18N::Handle->new(handle => $handle, language => $language);
    };

    return $self->{handles}->{$language};
}

sub _build_lexicon {
    my $self = shift;
    my ($lexicon, %params) = @_;

    my $lexicon_class = __PACKAGE__ . '::Lexicon::' . ucfirst($lexicon);

    Plack::Util::load_class($lexicon_class);

    return $lexicon_class->new(%params);
}

1;
__END__

=encoding utf-8

=head1 NAME

Plack::I18N - I18N for Plack

=head1 SYNOPSIS

    use Plack::I18N;
    use Plack::Builder;

    my $i18n = Plack::I18N->new(lexicon => 'gettext', locale_dir => 'locale/');

    builder {
        enable 'I18N', i18n => $i18n;

        sub {
            my $env = shift;

            my $handle = $env->{'plack.i18n.handle'};

            [200, [], [$handle->maketext('Hello')]];
        };
    };

=head1 DESCRIPTION

Plack::I18N is an easy way to add i18n to your application. Plack::I18N supports
both L<Locale::Maketext> C<*.pm> files and C<gettext> C<*.po> files. Use
whatevers suits better.

See L<http://github.com/vti/plack-i18n/examples/> directory for both examples.

=head2 Language detection

Language detection is done via HTTP headers, session cookies, URL path prefix
and so on. See L<Plack::Middleware::I18N> for details.

=head2 C<$env> parameters

Plack::Middleware::I18N registers the following C<$env> parameters:

=over

=item C<plack.i18n>

Holds Plack::I18N instance.

=item C<plack.i18n.language>

Current detected language. A shortcut for C<$env->{'plack.i18n'}->language>.

=item C<plack.i18n.handle>

A shortcut for C<$env->{'plack.i18n'}->handle($env->{'plack.i18n.language'})>.

=back

=head1 LICENSE

Copyright (C) Viacheslav Tykhanovskyi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

vti E<lt>viacheslav.t@gmail.comE<gt>

=cut

