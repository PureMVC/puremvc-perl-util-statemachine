#
#    PureMVC Perl5 Utility - StateMachine by Frederic Sullet <frederic.sullet@puremvc.org>
#
#	 PureMVC - Copyright(c) 2006-2011 Futurescale, Inc., Some rights reserved.
#	 Your reuse is governed by the Creative Commons Attribution 3.0 License
# 
package org::puremvc::perl5::multicore::utilities::statemachine::FSMInjector;

use strict; use warnings;

use org::puremvc::perl5::multicore::patterns::observer::Notifier;
our @ISA = qw( org::puremvc::perl5::multicore::patterns::observer::Notifier );

use org::puremvc::perl5::multicore::utilities::statemachine::State;
use org::puremvc::perl5::multicore::utilities::statemachine::StateMachine;

#**********************
#**********************
sub new {
  my ( $class, $state_machine_def ) = @_;
  
  die "Parameter 'state_machine_def' is mandatory\n" unless defined $state_machine_def;
  die "Parameter 'state_machine_def' must be a reference on HASH" unless ref $state_machine_def eq 'HASH';
    
  my $self = $class->SUPER::new();
  $self->{fsm} = $state_machine_def;
  bless $self, $class;

  return $self;
  
}

#**********************
sub inject {
  my $self = shift;
  
  my $state_machine = org::puremvc::perl5::multicore::utilities::statemachine::StateMachine->new();
  
  foreach my $state ( @{$self->states()} ) {
    $state_machine->registerState( $state, $self->isInitial( $state->{name} ) );
  }

  $self->getFacade()->registerMediator( $state_machine );
  
}

#**********************
sub states {
  my $self = shift;
  
  unless ( exists $self->{_states} ) {
    my @states = ();
    
    foreach my $state_def ( @{ $self->{fsm}->{'state'} } ) {
      my $state = $self->createState( $state_def );
      push( @states, $state );
    }

    $self->{_states} = \@states;
  }
  
  return $self->{_states};
  
}

#**********************
sub createState {
  my ( $self, $state_def ) = @_;
  
  my $name     = $state_def->{'name'};
  my $entering = $state_def->{'entering'};
  my $exiting  = $state_def->{'exiting'};
  my $changed  = $state_def->{'changed'};
  
  my $state = org::puremvc::perl5::multicore::utilities::statemachine::State->new( $name, $entering, $exiting, $changed );

  foreach my $trans_def ( @{ $state_def->{transition} } ) {
    $state->defineTrans( $trans_def->{'action'}, $trans_def->{'target'} );
  }

  return $state;
  
}

#**********************
sub isInitial {
  my ( $self, $state_name ) = @_;
  
  return $self->{fsm}->{'initial'} eq $state_name;
  
}

#**********************
#**********************
1;

__END__

=head1 NAME

C<< org::puremvc::perl5::multicore::utilities::statemachine::FSMInjector >>

B<inherits:>

=over 4

=item *

C<< org::puremvc::perl5::multicore::patterns::observer::Notifier >>

=back

Creates and registers a L<StateMachine|StateMachine> described with a B<hash reference>.

This allows reconfiguration of the L<StateMachine|StateMachine> without changing any code, as well as making it easier than creating all the L<State|State> instances and registering them with the L<StateMachine|StateMachine> at startup time.

=head1 DESCRIPTION

Here is an example of hash reference to describe a L<StateMachine|StateMachine> : 

  {
    'initial' => 'initial_state',
    'state' => [
                 {
                   'name' => 'state1',
                   'entering' => 'entering_state1',
                   'exiting' => 'exiting_state1',
                   'changed' => 'changed_state1',
                   'transition' => [
                                     {
                                       'target' => 'state2',
                                       'action' => 'transition12_action'
                                     },
                                     {
                                       'target' => 'state3',
                                       'action' => 'transition13_action'
                                     }
                                   ],
                 },
                 {
                   'name' => 'state2',
                   'exiting' => 'exiting_state2',
                   'transition' => [
                                     {
                                       'target' => 'state3',
                                       'action' => 'transition23_action'
                                     }
                                   ],
                 },
                 {
                   'name' => 'state3',
                   'changed' => 'changed_state3',
                   'transition' => [
                                     {
                                       'target' => 'state1',
                                       'action' => 'transition31_action'
                                     }
                                   ],
                 }
               ]
  };

As a tool, you can use L<XML::Simple|http://search.cpan.org/~grantm/XML-Simple-2.18/lib/XML/Simple.pm> CPAN module to produce the same from XML :

  use XML::Simple;
  
  my $xml = '<fsm initial="initial_state">
               <state name="state1" changed="changed_state1" entering="entering_state1" exiting="exiting_state1">
                 <transition action="transition12_action" target="state2" />
                 <transition action="transition13_action" target="state3" />
               </state>
               <state name="state2" exiting="exiting_state2">
                 <transition action="transition23_action" target="state3" />
               </state>
               <state name="state3" changed="changed_state3">
                 <transition action="transition31_action" target="state1" />
               </state>
             </fsm>';
  
  my $hash = XMLin( $xml, 'KeyAttr' => [], 'ForceArray' => [ 'state', 'transition' ] );
  my $fsm_injector = org::puremvc::perl5::utilities::statemachine::FSMInjector->new( $hash );

The C<< initial >> property can be empty.

A minimalist L<StateMachine|StateMachine> definition would be :

  {
    'initial' => '',
  };

or in XML :

  <fsm initial="" />

where no state at all are defined, not even an initial one.

=head1 INTERFACE

=head2 Methods

=over 4

=item FSMInjector

C<< sub FSMInjector( $state_machine_def ); >>

Constructor.

B<Parameters>

=over 8

=item *

C<< $state_machine_def - scalar >>

A reference on a hash holding the L<StateMachine|StateMachine> definition.

=back

=item createState

C<< sub createState( $state_def ); >>

Creates a L<State|State> instance from its definition.

B<Parameters>

=over 8

=item *

C<< $state_def - scalar >>

A reference on a hash array holding the L<State|State> definition.

=back

B<Returns>

C<< org::puremvc::perl5::utilities::statemachine::State >> - The created L<State|State> instance.

=item inject

C<< sub inject(); >>

Inject the L<StateMachine|StateMachine> into the PureMVC apparatus as a C<< Mediator >> called 'StateMachine'.

Creates the L<StateMachine|StateMachine> instance, registers all the L<states|State> and registers the L<StateMachine|StateMachine> instance with the C<< Facade >>. 

=item isInitial

C<< sub isInitial( $state_name ); >>

Says whether the given L<state|State> name represents the initial L<state|State>.

B<Parameters>

=over 8

=item *

C<< $state_name - String >>

The L<State|State> name to check.

B<Returns>

C<< scalar >> - 1 if this the name of the initial L<state|State>, "" otherwise.

=back

=item states

C<< sub states(); >>

Getter of the Array reference holding all the created L<states|State>.

B<Returns>

C<< scalar >> - Array reference holding all the created L<states|State>.

=back

=head2 Properties

=over 4

=item fsm

The hash array reference corresponding to the XML definition.

=item _states

Array reference holding all the created L<states|State>.

=back

=head1 SEE ALSO

L<org::puremvc::perl5::multicore::utilities::statemachine::State|State>

L<org::puremvc::perl5::multicore::utilities::statemachine::StateMachine|StateMachine>

=cut