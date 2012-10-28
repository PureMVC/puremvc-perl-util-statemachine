#
#    PureMVC Perl5 Utility - StateMachine by Frederic Sullet <frederic.sullet@puremvc.org>
#
#	 PureMVC - Copyright(c) 2006-2011 Futurescale, Inc., Some rights reserved.
#	 Your reuse is governed by the Creative Commons Attribution 3.0 License
# 
package org::puremvc::perl5::utilities::statemachine::StateMachine;

use strict; use warnings;

use org::puremvc::perl5::patterns::mediator::Mediator;
our @ISA = qw( org::puremvc::perl5::patterns::mediator::Mediator );

use base 'Exporter';
use constant NAME    => "StateMachine";
use constant ACTION  => NAME . "/notes/action";
use constant CHANGED => NAME . "/notes/changed";
use constant CANCEL  => NAME . "/notes/cancel";
our @EXPORT_OK = ('NAME', 'ACTION', 'CHANGED', 'CANCEL');

#**********************
#**********************
sub new {
  my $class = shift;
  
  my $self = $class->SUPER::new(NAME);
  bless( $self, $class );
  
  $self->{canceled} = 0;
  $self->{states} = {};
  
  return $self;
  
}

#**********************
sub onRegister {
  my $self = shift;
  
  return unless exists $self->{initial};
  
  $self->transitionTo( $self->{initial} );

}

#**********************
sub registerState {
  my ( $self, $state, $is_initial ) = @_;

  return unless defined $state;
  die "Provided state is not an instance of org::puremvc::perl5::utilities::statemachine::State\n"
    unless ref($state) eq 'org::puremvc::perl5::utilities::statemachine::State';
  return if exists $self->{states}->{$state->{name}};
      
  $self->{states}->{$state->{name}} = $state;
  
  $is_initial = 0 unless defined $is_initial;
  
  $self->{initial} = $state if $is_initial != 0;
  
}

#**********************
sub removeState {
  my ( $self, $state_name ) = @_;

  delete $self->{states}->{$state_name};
  
}

#**********************
sub transitionTo {
  my ( $self, $next_state, $data ) = @_;

  return unless defined $next_state;
  die "Provided state is not an instance of org::puremvc::perl5::utilities::statemachine::State\n"
    unless ref($next_state) eq 'org::puremvc::perl5::utilities::statemachine::State';
    
  $self->{canceled} = 0;

  # Exit the current state
  my $current_state = $self->currentState();
  $self->sendNotification( $current_state->{exiting}, $data, $next_state->{name} )
    if defined $current_state && defined $current_state->{exiting};
    
  # Check to see whether the exiting guard has canceled the transition
  if ( $self->{canceled} ) {
    $self->{canceled} = 0;
    return;
  }
  
  # Enter the next state
  $self->sendNotification( $next_state->{entering}, $data ) if defined $next_state->{entering};
  
  # Check to see whether the entering guard has canceled the transition
  if ( $self->{canceled} ) {
    $self->{canceled} = 0;
    return;
  }
  
  $self->currentState( $next_state );
  
  # Send the notification configured to be sent when this specific state becomes current
  $self->sendNotification( $next_state->{changed}, $data ) if defined $next_state->{changed};
  
  # Notify the app generally that the state changed and what the new state is
  $self->sendNotification( CHANGED, $next_state, $next_state->{name} );
  
}

#**********************
sub listNotificationInterests {
  return [ ACTION, CANCEL ];
}

#**********************
sub handleNotification {
  my ( $self, $note ) = @_;
  
  if ( $note->getName() eq ACTION ) {
    my $action = $note->getType();
    my $target = $self->currentState( $self->getTarget( $action ) );
    my $new_state = $self->{states}->{$target};
    $self->transitionTo( $new_state, $note->getBody() ) if defined $new_state;
  }
  
  if ( $note->getName() eq CANCEL ) {
    $self->{canceled} = 1;
  }

}

#**********************
sub currentState {
  my ( $self, $state ) = @_;
  
  # Getter
  return $self->{_view_component} unless defined $state;

  die "Provided state is not an instance of org::puremvc::perl5::utilities::statemachine::State\n"
    unless ref($state) eq 'org::puremvc::perl5::utilities::statemachine::State';
    
  # Setter
  $self->{_view_component} = $state;
  
}

#**********************
#**********************
1;

__END__

=head1 NAME

C<< org::puremvc::perl5::utilities::statemachine::StateMachine >>

B<inherits:>

=over 4

=item *

C<< org::puremvc::perl5::patterns::mediator::Mediator >>

=back

A Finite State Machine implementation for PureMVC.

=head1 DESCRIPTION

A C<< StateMachine >> object assumes these reponsibilities:

=over 4

=item *

Providing a method for L<State|State> objects registration.

=item *

Providing a method for L<State|State> objects removal.

=item *

Providing a method to transition from one L<State|State> to another.

=item *

Sending L<State's|State> defined C<< Notification >> when entering, exiting or finishing transitioning to it.

=back

As a C<< Mediator >>, a C<< StateMachine >> object's C<< _viewComponent >> property represents the current L<State|State> the object is in.

=head1 INTERFACE

=head2 Methods

=over 4

=item registerState

C<< sub registerState( $state, $is_initial ); >>

Register a L<State|State> object.

B<Parameters>

=over 8

=item *

C<< $state - org::puremvc::perl5::utilities::statemachine::State >>

The L<State|State> to register.

=item *

C<< $is_initial - scalar >>

Specifies whether the registered L<State|State> is the initial state. False is represented by a value different from 0.

=back

=item removeState

C<< sub removeState( $state_name ); >>

Remove a L<State|State> object from the C<< StateMachine >>.

B<Parameters>

=over 8

=item *

C<< $state_name - String >>

The name of the L<State|State> to remove. 

=back

=item transitionTo

C<< sub transitionTo( $next_state, $data ); >>

Transitions to the given L<State|State> from the current state.

Sends the exiting C<< notification >> for the current L<State|State> followed by the entering C<< notification >> for the new L<State|State>. Once finally transitioned to the new L<State|State>, the changed C<< notification >> for the new L<State|State> is sent.

If a data parameter is provided, it is included as the body of all three state-specific transition C<< notifications >>.

Finally, when all the state-specific transition C<< notifications >> have been sent, a C<< StateMachine::CHANGED >> C<< notification >> is sent, with the new L<State|State> object as the body and the name of the new L<State|State> in the type.

B<Parameters>

=over 8

=item *

C<< $next_state - org::puremvc::perl5::utilities::statemachine::State >>

The next L<State|State> to transition to.

=item *

C<< $data - * >>

Optional data that was sent in the C<< StateMachine.ACTION >> C<< notification >> body.

=back

=item currentState

C<< sub currentState( $new_state ); >>

Getter/setter for the C<< _viewComponent >> property.

When no parameter is given, behaves as a getter, as a setter otherwise.

The C<< _viewComponent >> property represents the current L<State|State> the machine is in.

B<Parameters>

=over 8

=item *

C<< $new_state - org::puremvc::perl5::utilities::statemachine::State >> - Optional

The new current L<State|State> of the C<< StateMachine >>.

B<Returns>

C<< org::puremvc::perl5::utilities::statemachine::State >> - The current L<State|State> of the C<< StateMachine >>.

=back

=back

=head2 Properties

=over 4

=item canceled

1 if a transition has been canceled, any other value otherwise.

=item initial

The initial L<State|State> of the C<< StateMachine >>.

=item states

Map of L<States|State> objects by name.

=back

=head1 SEE ALSO

L<org::puremvc::perl5::utilities::statemachine::FSMInjector|FSMInjector>

L<org::puremvc::perl5::utilities::statemachine::State|State>

=cut