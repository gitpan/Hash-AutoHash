use strict;
use warnings;
use Module::Build;

my $class = Module::Build->subclass
  (
   class => 'My::Builder',
   code => q{
       sub harness_switches { # turn off -w in Test::Harness
         shift->{properties}{debugger} ? qw(-d) : qw(-X);
       }
     },
  );

# my $builder = Module::Build->new
#   (
#    module_name         => 'Hash::AutoHash',
#    license             => 'perl',
#    dist_author         => q{Nat Goodman <natg@shore.net>},
#    dist_version_from   => 'lib/Hash/AutoHash.pm',
#    build_requires => {'Test::More' => 0.88,
# 		      'Test::Deep' => 0,
# 		      'Exporter' => 0,
# 		      'Tie::Hash::MultiValue' => 0,
# 		     },
#    requires =>       {'Carp' => 0,
# 		      'Scalar::Util' => 1.01,
# 		      'List::MoreUtils' => 0.09,
# 		      'Tie::Hash' => 1.00,
# 		      'Tie::ToObject' => 0,
# 		     },
#    add_to_cleanup      => [ 'Hash-AutoHash-*' ],
#    create_makefile_pl => 'traditional',
#   );

my $builder = $class->new
  (
   module_name         => 'Hash::AutoHash',
   license             => 'perl',
   dist_author         => q{Nat Goodman <natg@shore.net>},
   dist_version_from   => 'lib/Hash/AutoHash.pm',
   build_requires => {'Test::More' => 0.88,
		      'Test::Deep' => 0,
		      'Exporter' => 0,
		      'Tie::Hash::MultiValue' => 0,
		     },
   requires =>       {'Carp' => 0,
		      'Scalar::Util' => 1.01,
		      'List::MoreUtils' => 0.09,
		      'Tie::Hash' => 1.00,
		      'Tie::ToObject' => 0,
		     },
   add_to_cleanup      => [ 'Hash-AutoHash-*' ],
   create_makefile_pl => 'traditional',
  );

$builder->create_build_script();
