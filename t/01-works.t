#!/usr/bin/perl 

use strict;
use warnings;

use Test::Most qw{no_plan};
use Carp::Always;
BEGIN{ print qq{\n} for 1..10};

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
BEGIN {
   package My::Test;
   use Moose;
   use MooseX::Error::Trap;
   
   trap odd => 'not_odd';
   sub odd  { 
      my ($self,$in) = @_;
      die unless $in % 2 ;
      return 1;
   };
   sub not_odd { 0 }; 

   trap even => sub{ 0 };
   sub even  { 
      my ($self,$in) = @_;
      die if $in % 2 ;
      return 1;
   };

   has non_numeric => 
      is => 'rw',
      isa => 'CodeRef',
      default => sub{sub{ shift->non_numeric_return }},
   ;

   has non_numeric_return => 
      is => 'rw',
      isa => 'Bool',
      default => 0
   ;

   trap num => 'non_numeric';
   sub num  { 
      my ($self,$in) = @_;
      die unless $in =~ m/\d/;
   };
   
};

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
ok my $o = My::Test->new(), q{new obj} ;
ok $o->odd(1), q{1 is odd};
ok!$o->odd(2), q{2 is not odd};

ok!$o->even(1), q{1 is not even};
ok $o->even(2), q{2 is even};

ok $o->num(1), q{1 is numeric};
ok!$o->num(''),q{'' is not numeric};






