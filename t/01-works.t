#!/usr/bin/perl;

use strict;
use warnings;

use Test::Most qw{no_plan};

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
BEGIN {
print qq{\n} for 1..10;
package My::Test;
use Moose;
use MooseX::Error::Trap;

trap 'find', 'trap_silent' ;
sub find {
   my $self = shift;
   my $haystack = { map{ $_ => 1 } 1..10 };
   # doing this only so that we do not depend on Quantum::Superpositions
   my @found = grep{ $haystack->{$_} } @_;
   die {msg => 'nothing found', return => []}
      unless scalar(@found);
   return \@found;
}

sub trap_silent {
   my ($self,$error) = @_;
   warn $error->{msg} || 'Something horrable happened, no further info provided';
   return $error->{return};
}

trap 'fail';
sub fail {
   die 'this fails';
}

   
}

#---------------------------------------------------------------------------
#  
#---------------------------------------------------------------------------
ok( my $t  = My::Test->new() );
eq_or_diff( 
   $t->find(111 ,2), 
   2,
);
lives_ok { $t->find(0) }
        q{just a warning};

dies_ok  { $t->fail }
        q{now death};

