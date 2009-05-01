package MooseX::Error::Trap;

our $VERSION = '0.01';
use Moose;
use Moose::Exporter;
Moose::Exporter->setup_import_methods(
   with_caller => [qw{trap}],
);

sub ____register_trap_dispatch {
   my ($caller,$trap_method,$dispatch_method) = @_;
   my $meta   = Class::MOP::Class->initialize($caller);
   #---------------------------------------------------------------------------
   #  Make sure that we have a storage location for trap_dispatch
   #---------------------------------------------------------------------------
   unless ( $meta->find_attribute_by_name('trap_dispatch') ) {
      $meta->add_attribute(
               'trap_dispatch',
               is => 'rw',
               isa => 'HashRef',
               default => sub{{}},
      );
   }

use Data::Dumper;

   if ( $meta->find_attribute_by_name('trap_dispatch')->has_write_method ) {
      #THIS IS RATHER FORECFUL!!
      $meta->find_attribute_by_name('trap_dispatch')->set_value($meta,{ 
         grep{ defined} 
            #$meta->find_attribute_by_name('trap_dispatch')->get_value($meta) || undef
            $trap_method => $dispatch_method,
      });


   }
   else {
      die 'Was not able to set the proper dispatcher as requested, likely trap_dispatch is set to "ro".';
   }

   
   
}

sub trap {
   my ($caller,$trap_method,$dispatch_method) = @_;

   #---------------------------------------------------------------------------
   #  Make sure that were dealing with sane input
   #---------------------------------------------------------------------------
   confess sprintf(q{The specified dispatch method (%s) is not available via %s},
                   $dispatch_method, 
                   ref($caller) || $caller,
                  ) if defined $dispatch_method && ! $caller->can($dispatch_method) ;
   my $meta   = Class::MOP::Class->initialize($caller);

   
   #---------------------------------------------------------------------------
   #  build our trap
   #---------------------------------------------------------------------------
   $meta->add_around_method_modifier(
            $trap_method,
            sub{  my $next = shift;
                  my $self = shift;

                  eval { $self->$next(@_) }
                  or do{ #$self->trap_dispatch;
                     return ( defined($dispatch_method) ) 
                            ? $self->$dispatch_method($@) 
                            : die $@ ;
                  };
            },
   );
}
   

no MooseX::Error::Trap;

1;
__END__





use warnings;
use strict;

=head1 NAME

MooseX::Error::Trap - The great new MooseX::Error::Trap!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use MooseX::Error::Trap;

    my $foo = MooseX::Error::Trap->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

NOTBENH, C<< <NOTBENH at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-error-trap at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Error-Trap>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::Error::Trap


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Error-Trap>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Error-Trap>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-Error-Trap>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-Error-Trap/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 NOTBENH, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of MooseX::Error::Trap
