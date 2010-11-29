use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'MooseX::Error::Trap',
    license             => 'perl',
    dist_author         => 'NOTBENH <NOTBENH@cpan.org>',
    dist_version_from   => 'lib/MooseX/Error/Trap.pm',
    build_requires => {
        'Module::Build' => 0,
        'Test::More'    => 0,
        'Test::Most'    => 0,
        'Moose'         => 0,
    },
    add_to_cleanup      => [ 'MooseX-Error-Trap-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
