package org::puremvc::perl5::multicore::utilities::statemachine::unittests::StateMachineTest;

use strict; use warnings;

use Test::More;
use org::puremvc::perl5::multicore::patterns::facade::Facade;

BEGIN { print "############### StateMachine tests\n"; }

BEGIN { use_ok( 'org::puremvc::perl5::multicore::utilities::statemachine::StateMachine' ); }
require_ok( 'org::puremvc::perl5::multicore::utilities::statemachine::StateMachine' );

#**********************
#**********************
test();

#**********************
sub test {
  testConstructor();
  testMethods();
  testRegisterState();
  testRemoveState();
  testCurrentState();
  testTransitionTo();

}

#**********************
sub testConstructor {

  print "########## testConstructor\n";

  my $state_machine = org::puremvc::perl5::multicore::utilities::statemachine::StateMachine->new();
  
  is(defined $state_machine, 1, 'Expecting $state_machine to be defined');
  isa_ok($state_machine, 'org::puremvc::perl5::multicore::utilities::statemachine::StateMachine');
  is($state_machine->{canceled}, 0, 'Expecting $state_machine->{canceled} to be 0');
  is(ref $state_machine->{states}, "HASH", 'Expecting $state_machine->{states} to be "HASH"');

}

#**********************
sub testMethods {

  print "########## testMethods\n";

  my $state_machine = org::puremvc::perl5::multicore::utilities::statemachine::StateMachine->new();
  
  can_ok($state_machine, "registerState");
  can_ok($state_machine, "removeState");
  can_ok($state_machine, "transitionTo");
  can_ok($state_machine, "currentState");

}

#**********************
sub testRegisterState {

  print "########## testRegisterState\n";

  my $state_machine = org::puremvc::perl5::multicore::utilities::statemachine::StateMachine->new();
  my $state1 = org::puremvc::perl5::multicore::utilities::statemachine::State->new("state1");
  
  $state_machine->registerState( $state1 );
  is(exists $state_machine->{states}->{$state1->{name}}, 1, 'Expecting exists $state_machine->{states}->{$state1->{name}} to be 1');
  is(exists $state_machine->{initial}, "", 'Expecting exists $state_machine->{initial} to be ""');

  my $state2 = org::puremvc::perl5::multicore::utilities::statemachine::State->new("state2");
  $state_machine->registerState( $state2, 1 );
  is(exists $state_machine->{states}->{$state2->{name}}, 1, 'Expecting exists $state_machine->{states}->{$state2->{name}} to be 1');
  is(exists $state_machine->{initial}, 1, 'Expecting exists $state_machine->{initial} to be 1');
  isa_ok($state_machine->{initial}, 'org::puremvc::perl5::multicore::utilities::statemachine::State');

  # test bad type state registration
  eval { $state_machine->registerState( "state" ); };
  isnt($@, "", 'Expecting registration to crash');
}

#**********************
sub testRemoveState {

  print "########## testRemoveState\n";

  my $state_machine = org::puremvc::perl5::multicore::utilities::statemachine::StateMachine->new();
  my $state1 = org::puremvc::perl5::multicore::utilities::statemachine::State->new("state1");
  
  $state_machine->registerState( $state1 );
  $state_machine->removeState( $state1->{name} );
  is(exists $state_machine->{states}->{$state1->{name}}, "", 'Expecting exists $state_machine->{states}->{$state1->{name}} to be ""');

  # test removal of non existing state does not crash
  eval { $state_machine->removeState( $state1 ); };
  is($@, "", 'Expecting removal not to crash');

}

#**********************
sub testCurrentState {

  print "########## testCurrentState\n";

  my $state_machine = org::puremvc::perl5::multicore::utilities::statemachine::StateMachine->new();
  is(defined $state_machine->currentState(), "", 'Expecting defined $state_machine->currentState() to be ""');

  my $state1 = org::puremvc::perl5::multicore::utilities::statemachine::State->new("state1");
  $state_machine->currentState( $state1 );
  my $current_state = $state_machine->currentState();
  is(defined $current_state, 1, 'Expecting defined $current_state to be 1');
  is($current_state, $state1, 'Expecting $current_state to be $state1');
  
}

#**********************
sub testTransitionTo {

  print "########## testTransitionTo\n";

  my $state_machine = org::puremvc::perl5::multicore::utilities::statemachine::StateMachine->new();
  my $state1 = org::puremvc::perl5::multicore::utilities::statemachine::State->new("state1");
  my $facade = org::puremvc::perl5::multicore::patterns::facade::Facade->getInstance( "key1");
  
  $state_machine->initializeNotifier( "key1" ); 
  
  $state_machine->registerState( $state1 );
  $state_machine->currentState( $state1 );
  $state_machine->transitionTo();
  is($state_machine->currentState(), $state1, 'Expecting $state_machine->currentState() to be $state1');

  my $state2 = org::puremvc::perl5::multicore::utilities::statemachine::State->new("state2");
  $state_machine->registerState( $state2, 1 );
  $state_machine->transitionTo( $state2 );
  is($state_machine->currentState(), $state2, 'Expecting $state_machine->currentState() to be $state2');

}

#**********************
#**********************
1;