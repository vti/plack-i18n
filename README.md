# NAME

Plack::I18N - I18N for Plack

# SYNOPSIS

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

# DESCRIPTION

Plack::I18N is an easy way to add i18n to your application. Plack::I18N supports
both [Locale::Maketext](https://metacpan.org/pod/Locale::Maketext) `*.pm` files and `gettext` `*.po` files. Use
whatevers suits better.

See [http://github.com/vti/plack-i18n/examples/](http://github.com/vti/plack-i18n/examples/) directory for both examples.

## Language detection

Language detection is done via HTTP headers, session cookies, URL path prefix
and so on. See [Plack::Middleware::I18N](https://metacpan.org/pod/Plack::Middleware::I18N) for details.

## `$env` parameters

Plack::Middleware::I18N registers the following `$env` parameters:

- `plack.i18n`

    Holds Plack::I18N instance.

- `plack.i18n.language`

    Current detected language. A shortcut for `$env-`{'plack.i18n'}->language>.

- `plack.i18n.handle`

    A shortcut for `$env-`{'plack.i18n'}->handle($env->{'plack.i18n.language'})>.

# LICENSE

Copyright (C) Viacheslav Tykhanovskyi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

vti <viacheslav.t@gmail.com>
