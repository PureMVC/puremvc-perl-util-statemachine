#
#    PureMVC Perl5 Utility - StateMachine by Frederic Sullet <frederic.sullet@puremvc.org>
#
#	 PureMVC - Copyright(c) 2006-2011 Futurescale, Inc., Some rights reserved.
#	 Your reuse is governed by the Creative Commons Attribution 3.0 License
# 
package org::puremvc::perl5::utilities::statemachine::State;

use strict; use warnings;

#**********************
#**********************
sub new {
  my ( $class, $name, $entering, $exiting, $changed ) = @_;
  
  my $self = {};
  bless( $self, $class );

  $self->{name}        = $name;
  $self->{entering}    = $entering if defined $entering;
  $self->{exiting}     = $exiting if defined $exiting;
  $self->{changed}     = $changed if defined $changed;
  $self->{transitions} = {};
  
  return $self;
  
}

#**********************
sub defineTrans {
  my ( $self, $action, $target ) = @_;
  
  return if defined $self->getTarget( $action );

  $self->{transitions}->{$action} = $target;
  
}

#**********************
sub removeTrans {
  my ( $self, $action ) = @_;
  
  delete $self->{transitions}->{$action};
  
}

#**********************
sub getTarget {
  my ( $self, $action ) = @_;
  
  return $self->{transitions}->{$action};
  
}

#**********************
#**********************
1;

__END__

=head1 NAME

C<< org::puremvc::perl5::utilities::statemachine::State >>

Defines a state in a PureMVC application.

=head1 DESCRIPTION

A finite state machine C<< State >> object. 

=over 4

=item *

is identified by its name.

=item *

Optionally defines PureMVC C<< Notification >> names to be sent by the L<StateMachine|StateMachine> when

=over 8

=item *

the L<StateMachine|StateMachine> current state is changed to this one.

=item *

the L<StateMachine|StateMachine> current state is this one and is about to enter it.

=item *

the L<StateMachine|StateMachine> current state is this one and is about to exit it.

=back 

=item *

Optionally defines transitions to other states (target states) for a given action.

=back

=head1 INTERFACE

=head2 Methods

=over 4

=item new

C<< sub new( $name, $entering, $exiting, $changed ); >>

Contructor.

B<Parameters>

=over 8

=item *

C<< $name - String >>

Name identifing the C<< State >>.

=item *

C<< $entering - String >>

PureMVC C<< Notification >> name to be sent by the L<StateMachine|StateMachine> when the L<StateMachine|StateMachine> current state is this one and is about to enter it.

=item *

C<< $exiting - String >>

PureMVC C<< Notification >> name to be sent by the L<StateMachine|StateMachine> when the L<StateMachine|StateMachine> current state is this one and is about to exit it.

=item *

C<< $changed - String >>

PureMVC C<< Notification >> name to be sent by the L<StateMachine|StateMachine> when the L<StateMachine|StateMachine> current state is changed to this one.

=back

=item defineTrans

C<< sub defineTrans( $action, $target ); >>

Defines a transition to a target state base on an action.

B<Parameters>

=over 8

=item *

C<< $action - String >>

The name of the StateMachine.ACTION C<< Notification >> type. 

=item *

C<< $target - String >>

The name of the target state to transition to.

=back

=item getTarget

C<< sub getTarget( $action ); >>

Get the target state name for a given action.

B<Parameters>

=over 8

=item *

C<< $action - String >>

The name of the StateMachine.ACTION C<< Notification >> type. 

B<Returns>

C<< scalar >> - Name of the target state for action C<< $action >> if one exists, C<< undef >> otherwise.

=back

=item removeTrans

C<< sub removeTrans( $action ); >>

Remove the transition identified by C<< $action >>.

B<Parameters>

=over 8

=item *

C<< $action - String >>

The name of the StateMachine.ACTION C<< Notification >> type identifying transtion to be removed. 

=back

=back

=head2 Properties

=over 4

=item changed

See C<< new >> constructor method.

=item entering

See C<< new >> constructor method.

=item exiting

See C<< new >> constructor method.

=item name

See C<< new >> constructor method.

=item transitions

Transition map of actions to target states.

=back

=head1 SEE ALSO

L<org::puremvc::perl5::utilities::statemachine::FSMInjector|FSMInjector>

L<org::puremvc::perl5::utilities::statemachine::StateMachine|StateMachine>

=cut