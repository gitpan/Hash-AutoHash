use lib qw(t);
use strict;
use Carp;
use Test::More;
use Test::Deep;
require 'autohash.TieMV.pm';	# example tied hash class
use autohashUtil;
use Hash::AutoHash qw(autohash_new autohash_hash autohash_tie 
			      autohash_wrap autohash_wraptie autohash_wrapobj);
use Hash::AutoHash qw(autohash_exists);

my @INITIAL_VALUES=(key0=>'value01',key1=>'value11',key2=>'value21');
my %INITIAL_VALUES=@INITIAL_VALUES;
sub test_exists {
  my($label,$how_many,$ok_hash,$ok_object)=@_;
  $label.=' with'.($how_many==1? ' 1 key': " $how_many keys");
  my(@ok_func,@fail_func,@ok_hash,@fail_hash,@ok_exthash,@fail_exthash,@ok_extobj,@fail_extobj);
  for(my $i=0; $i<=3; $i++) {
    my $correct=($i<$how_many || $i>2)? undef: 1;
    my $key="key$i";
    autohash_exists($autohash,$key) eq $correct? push(@ok_func,$key): push(@fail_func,$key);
    exists $autohash->{$key} eq $correct? push(@ok_hash,$key): push(@fail_hash,$key);
    if ($ok_hash) {
      exists $hash{$key} eq $correct? push(@ok_exthash,$key): push(@fail_exthash,$key);
    } else { 			# should always be false
      !exists $hash{$key}? push(@ok_exthash,$key): push(@fail_exthash,$key);
    }
    if ($ok_object) {
      $object->EXISTS($key) eq $correct? push(@ok_extobj,$key): push(@fail_extobj,$key);
    } else {			# $object should be empty of undef
      !$object? push(@ok_extobj,$key): push(@fail_extobj,$key);
    }
  }
  my $pass=1;
  $pass&&=_report("$label exists via function",@ok_func,@fail_func);
  $pass&&=_report("$label exists as hash",@ok_hash,@fail_hash);
  $pass&&=_report("$label exists external hash",@ok_exthash,@fail_exthash);
  $pass&&=_report("$label exists external object",@ok_extobj,@fail_extobj);
  pass($label) if $pass && !$VERBOSE; # print if all tests passed and tests didn't print passes
}

my $constructor='autohash_new (real)';
for(my $i=0; $i<=3; $i++) {
  undef $autohash; undef $object; untie %hash; undef %hash;
  my @initial_values=(map {'key'.$_=>$INITIAL_VALUES{'key'.$_}} ($i..2));
  $autohash=autohash_new @initial_values;
  test_exists($constructor,$i);
}
my $constructor='autohash_new (tie)';
for(my $i=0; $i<=3; $i++) {
  undef $autohash; undef $object; untie %hash; undef %hash;
  my @initial_values=(map {'key'.$_=>$INITIAL_VALUES{'key'.$_}} ($i..2));
  $autohash=autohash_new ['TieMV'],@initial_values;
  test_exists($constructor,$i);
}
my $constructor='autohash_new (wrap real)';
for(my $i=0; $i<=3; $i++) {
  undef $autohash; undef $object; untie %hash; undef %hash;
  my @initial_values=(map {'key'.$_=>$INITIAL_VALUES{'key'.$_}} ($i..2));
  $autohash=autohash_new \%hash,@initial_values;
  test_exists($constructor,$i,'hash',undef);
}
my $constructor='autohash_new (wrap tied)';
for(my $i=0; $i<=3; $i++) {
  undef $autohash; undef $object; untie %hash; undef %hash;
  my @initial_values=(map {'key'.$_=>$INITIAL_VALUES{'key'.$_}} ($i..2));
  $object=tie %hash,'TieMV';
  $autohash=autohash_new \%hash,@initial_values;
  test_exists($constructor,$i,'hash','object');
}
my $constructor='autohash_new (wrap object)';
for(my $i=0; $i<=3; $i++) {
  undef $autohash; undef $object; untie %hash; undef %hash;
  my @initial_values=(map {'key'.$_=>$INITIAL_VALUES{'key'.$_}} ($i..2));
  $object=tie %hash,'TieMV';
  $autohash=autohash_new $object,@initial_values;
  test_exists($constructor,$i,'hash','object');
}
my $constructor='autohash_new (wraptie)';
for(my $i=0; $i<=3; $i++) {
  undef $autohash; undef $object; untie %hash; undef %hash;
  my @initial_values=(map {'key'.$_=>$INITIAL_VALUES{'key'.$_}} ($i..2));
  $autohash=autohash_new [\%hash,'TieMV'],@initial_values;
  $object=tied(%hash);
  test_exists($constructor,$i,'hash','object');
}

my $constructor='autohash_hash';
for(my $i=0; $i<=3; $i++) {
  undef $autohash; undef $object; untie %hash; undef %hash;
  my @initial_values=(map {'key'.$_=>$INITIAL_VALUES{'key'.$_}} ($i..2));
  $autohash=autohash_hash @initial_values;
  test_exists($constructor,$i);
}
my $constructor='autohash_tie';
for(my $i=0; $i<=3; $i++) {
  undef $autohash; undef $object; untie %hash; undef %hash;
  my @initial_values=(map {'key'.$_=>$INITIAL_VALUES{'key'.$_}} ($i..2));
  $autohash=autohash_tie TieMV,@initial_values;
  test_exists($constructor,$i);
}
my $constructor='autohash_wrap (real)';
for(my $i=0; $i<=3; $i++) {
  undef $autohash; undef $object; untie %hash; undef %hash;
  my @initial_values=(map {'key'.$_=>$INITIAL_VALUES{'key'.$_}} ($i..2));
  $autohash=autohash_wrap %hash,@initial_values;
  test_exists($constructor,$i,'hash',undef);
}
my $constructor='autohash_wrap (tied)';
for(my $i=0; $i<=3; $i++) {
  undef $autohash; undef $object; untie %hash; undef %hash;
  my @initial_values=(map {'key'.$_=>$INITIAL_VALUES{'key'.$_}} ($i..2));
  $object=tie %hash,'TieMV';
  $autohash=autohash_wrap %hash,@initial_values;
  test_exists($constructor,$i,'hash','object');
}
my $constructor='autohash_wrapobj';
for(my $i=0; $i<=3; $i++) {
  undef $autohash; undef $object; untie %hash; undef %hash;
  my @initial_values=(map {'key'.$_=>$INITIAL_VALUES{'key'.$_}} ($i..2));
  $object=tie %hash,'TieMV';
  $autohash=autohash_wrapobj $object,@initial_values;
  test_exists($constructor,$i,'hash','object');
}
my $constructor='autohash_wraptie';
for(my $i=0; $i<=3; $i++) {
  undef $autohash; undef $object; untie %hash; undef %hash;
  my @initial_values=(map {'key'.$_=>$INITIAL_VALUES{'key'.$_}} ($i..2));
  $autohash=autohash_wraptie %hash,TieMV,@initial_values;
  $object=tied(%hash);
  test_exists($constructor,$i,'hash','object');
}

done_testing();
