use strict;
use warnings;
use utf8;

use lib 't/lib';

use Test::More;
use Test::Fatal;
use Test::Requires {
    'Locale::Maketext::Lexicon' => '0',
    'I18N::AcceptLanguage'      => '0'
};

use Plack::I18N;

subtest 'returns default langauge' => sub {
    my $i18n = _build_i18n();

    is $i18n->default_language, 'en';
};

subtest 'returns specified languages' => sub {
    my $i18n = _build_i18n(languages => [qw/de uk/]);

    is_deeply [$i18n->languages], [qw/de uk/];
};

subtest 'returns overwritten default language' => sub {
    my $i18n = _build_i18n(default_language => 'ru');

    is $i18n->default_language, 'ru';
};

subtest 'detects languages from lexicon' => sub {
    my $i18n = _build_i18n();

    is_deeply [$i18n->languages], [qw/en ru/];
};

subtest 'defaults to default language on uknown language' => sub {
    my $i18n = _build_i18n();

    is($i18n->handle('de')->maketext('Hello'), 'Hello');
};

subtest 'defaults to default language on uknown translation' => sub {
    my $i18n = _build_i18n();

    is($i18n->handle('ru')->maketext('Hi'), 'Hi');
};

subtest 'returns handle' => sub {
    my $i18n = _build_i18n();

    my $handle = $i18n->handle('ru');

    is $handle->maketext('Hello'), 'Привет';
};

subtest 'caches handle' => sub {
    my $i18n = _build_i18n();

    my $ref     = $i18n->handle('ru');
    my $new_ref = $i18n->handle('ru');

    is $ref, $new_ref;
};

sub _build_i18n {
    Plack::I18N->new(
        i18n_class => 'MyApp::I18N',
        locale_dir => 't/lib/MyApp/I18N',
        lexicon    => 'maketext',
        @_
    );
}

done_testing;
