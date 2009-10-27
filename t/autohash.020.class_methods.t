use lib qw(t);
use strict;
use Carp;
use Test::More;
use Test::Deep;
# use autohashUtil;
use Hash::AutoHash;
my $autohash;

# It's kinda silly to test import and new, since we'd have failed miserably long ago
#   if these were broken :) Included here for completeness.
import Hash::AutoHash qw(autohash_new);
$autohash=autohash_new();
ok($autohash,'import: success');
eval {import Hash::AutoHash qw(import);};
ok($@=~/not exported/,'import: not exported');
eval {import Hash::AutoHash qw(not_defined);};
ok($@=~/not exported/,'import: not defined');

$autohash=new Hash::AutoHash;
ok($autohash,'new');

my $can=can Hash::AutoHash('can');
is(ref $can,'CODE','can: can');
my $can=can Hash::AutoHash('not_defined');
ok(!$can,'can: can\'t');

my $isa=isa Hash::AutoHash('Hash::AutoHash');
is($isa,1,'isa: is Hash::AutoHash');
my $isa=isa Hash::AutoHash('UNIVERSAL');
is($isa,1,'isa: is UNIVERSAL');
my $isa=isa Hash::AutoHash('not_defined');
ok(!$isa,'isa: isn\'t');

my $version=VERSION Hash::AutoHash;
is($version,$Hash::AutoHash::VERSION,'VERSION');

done_testing();
