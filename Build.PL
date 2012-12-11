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

my $builder = $class->new
  (
   module_name         => 'Hash::AutoHash',
   license             => 'perl',
   dist_author         => q{Nat Goodman <natg@shore.net>},
   configure_requires=>{'Module::Build' => 0.4,
		       },
   build_requires => {'Exporter' => 5.58,
		      'Test::Deep' => 0.11,
		      'Test::More' => 0.88,
		      'Tie::Hash::MultiValue' => 0,
		     },
   requires =>       {'Carp' => 0,
		      'Scalar::Util' => 1.01,
		      'List::MoreUtils' => 0.09,
		      'Tie::Hash' => 1.00,
		      'Tie::ToObject' => 0,
		      perl => '5.8.3',
		     },
   add_to_cleanup      => [ 'Hash-AutoHash-*' ],
   create_makefile_pl => 'small',
  );

$builder->create_build_script();
