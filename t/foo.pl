use strict;
use Carp;

opendir(DIR,'.') || confess "Cannot open current directory: $!";
my @tfiles=grep /\.t$/,readdir DIR;

for my $file (sort @tfiles) {
  open(FILE,"< $file") || confess "Cannot open $file for read: $!";
  my @lines=<FILE>;
  close FILE;
  chomp @lines;
  my($changed,$carp,$test_more,$done_testing);
  $changed=0;
  for (my $i=0; $i<@lines; $i++) {
    $changed++, $lines[$i]='use lib qw(t);' if $lines[$i]=~/^use lib map/;
    $changed++, $lines[$i]='use Test::More;' if $lines[$i]=~/^use Test::More qw/;
    $carp=$i if $lines[$i]=~/^use Carp/;
    $test_more=$i if $lines[$i]=~/^use Test::More/;
    $done_testing=$i if $lines[$i]=~/^\s*done_testing/;
  }
  if (!$test_more && $carp) {
    splice(@lines,$carp+1,0,'use Test::More;');
    $changed++;
  }
  unless ($done_testing) {
    while($lines[$#lines]=~/^\s*$/) { # strip trailing blank lines
      pop @lines;
    }
    push(@lines,'','done_testing();');
    $changed++;
  }
  print "$file: $changed changes\n";
  # write file if changed
  if ($changed) {
    open(FILE,"> $file") || confess "Cannot open $file for write: $!";
#    *FILE=*STDOUT;
    print FILE join("\n",@lines),"\n";
    close FILE;
  }
}

#map {print "$_\n"} sort @tfiles;
