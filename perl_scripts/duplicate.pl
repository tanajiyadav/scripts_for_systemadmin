#!/usr/bin/perl
use strict;
use warnings;
use File::Find;
use Digest::MD5;
####find diplicate files######
sub find_dups(@) 
{

  #list of dir to search
  my @dir_list = @_;
  if ($#dir_list < 0){
    return (undef);
  }
  
  my %files;
  find(sub {
    -f && push @{$files{(stat(_))[7]}}, $File::Find::name
  }, @dir_list
  );
  my @result = ();
  
  foreach my $size (keys %files){
    if ($#{$files{$size}} < 1){
    next;
    }
    my %md5;
    
    foreach my $cur_file (@{$files{$size}}) {
    open(FILE, $cur_file) or next;
    binmode(FILE);
    push @{$md5{Digest::MD5->new->addfile(*FILE)->hexdigest}
    }, $cur_file;
    close (FILE);
    }
    foreach my $hash (keys %md5){
    if ($#{$md5{$hash}} >= 1){
      push(@result,[@{$md5{$hash}}]);
    }
   }
  }
  return @result  
}

my @dups = find_dups(@ARGV);

foreach my $cur_dup (@dups) {
  print "Duplicates\n";
  foreach my $cur_file (@$cur_dup){
  #system("rm $cur_file");
  print "\t$cur_file\n";
  }
}

