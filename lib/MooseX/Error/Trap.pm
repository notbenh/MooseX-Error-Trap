package MooseX::Error::Trap;
use Moose;
use Moose::Exporter;
Moose::Exporter->setup_import_methods(
   with_caller => [qw{trap}],
);

# ABSTRACT: Create error traps for methods.


=head1 SYNOPSIS

Allows you to wrap any method in an eval and specify a dispatch method if the eval trips.

   package My::Test;
   use Moose;
   use MooseX::Error::Trap;

   trap 'some_method', 'what_to_do';
   sub some_method {
      ...
   }

   sub what_to_do {
      my ($self, $error) = @_;
      ...
   }

=head1 Exported Keyword

=head2 trap

   trap 'run_method_name', 'error_handling_method_name';

Will wrap any calls to 'run_method_name' in an eval, currently you can only have one deligation method.

=cut

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
   
=head1 TODO

=over 4

=item * A way to modify the relationship between the method run and the deferment method at runtime.

=back 

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

Thanks again to team Moose.

=head1 COPYRIGHT & LICENSE

Copyright 2009 NOTBENH, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

no MooseX::Error::Trap;
1; # End of MooseX::Error::Trap
