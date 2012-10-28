package org::puremvc::perl5::utilities::statemachine::unittests::FSMInjectorTest;

use strict; use warnings;

use Test::More;
use XML::Simple;

use org::puremvc::perl5::patterns::facade::Facade;
use org::puremvc::perl5::utilities::statemachine::StateMachine;

BEGIN { print "############### FSMInjector tests\n"; }

BEGIN { use_ok( 'org::puremvc::perl5::utilities::statemachine::FSMInjector' ); }
require_ok( 'org::puremvc::perl5::utilities::statemachine::FSMInjector' );

my $fsm_xml0 = '<fsm initial="" />';
my $fsm_xml1 = '<fsm initial="initial_state">
                  <state name="state11" />
                </fsm>';
my $fsm_xml2 = '<fsm initial="initial_state">
                  <state name="state21" entering="entering_state21">
                    <transition action="transition211_action" target="state22" />
                    <transition action="transition212_action" target="state23" />
                  </state>
                  <state name="state22" exiting="exiting_state22">
                    <transition action="transition221_action" target="state23" />
                  </state>
                  <state name="state23" changed="changed_state23">
                    <transition action="transition231_action" target="state21" />
                  </state>
                </fsm>';

#**********************
#**********************
test();

#**********************
sub test {
  testConstructor();
  testMethods();
  testIsInitial();
  testCreateState();
  testStates();
  testInject();

}

#**********************
sub testConstructor {

  print "########## testConstructor\n";

  my $fsm_injector = org::puremvc::perl5::utilities::statemachine::FSMInjector->new( { 'initial' => '' } );
  is(defined $fsm_injector, 1, 'Expecting $fsm_injector to be defined');
  isa_ok($fsm_injector, 'org::puremvc::perl5::utilities::statemachine::FSMInjector');
  is(defined $fsm_injector->{fsm}, 1, 'Expecting defined $fsm_injector->{fsm} to be 1');
  is(ref $fsm_injector->{fsm}, "HASH", 'Expecting $fsm_injector->{fsm} to be "HASH"');
  is(scalar(keys %{$fsm_injector->{fsm}}), 1, 'Expecting scalar(keys %{$fsm_injector->{fsm}}) to be 1');
  is(exists $fsm_injector->{fsm}->{initial}, 1, 'Expecting exists $fsm_injector->{fsm}->{initial} to be 1');
  is($fsm_injector->{fsm}->{initial}, "", 'Expecting $fsm_injector->{fsm}->{initial} to be ""');

  my $hash = XMLin( $fsm_xml0, 'KeyAttr' => [], 'ForceArray' => [ 'state', 'transition' ] );
  $fsm_injector = org::puremvc::perl5::utilities::statemachine::FSMInjector->new( $hash );
  is(defined $fsm_injector, 1, 'Expecting $fsm_injector to be defined');
  isa_ok($fsm_injector, 'org::puremvc::perl5::utilities::statemachine::FSMInjector');
  is(defined $fsm_injector->{fsm}, 1, 'Expecting defined $fsm_injector->{fsm} to be 1');
  is(ref $fsm_injector->{fsm}, "HASH", 'Expecting $fsm_injector->{fsm} to be "HASH"');
  is(scalar(keys %{$fsm_injector->{fsm}}), 1, 'Expecting scalar(keys %{$fsm_injector->{fsm}}) to be 1');
  is(exists $fsm_injector->{fsm}->{initial}, 1, 'Expecting exists $fsm_injector->{fsm}->{initial} to be 1');
  is($fsm_injector->{fsm}->{initial}, "", 'Expecting $fsm_injector->{fsm}->{initial} to be ""');
  
  $hash = XMLin( $fsm_xml1, 'KeyAttr' => [], 'ForceArray' => [ 'state', 'transition' ] );
  $fsm_injector = org::puremvc::perl5::utilities::statemachine::FSMInjector->new( $hash );
  is(defined $fsm_injector, 1, 'Expecting $fsm_injector to be defined');
  isa_ok($fsm_injector, 'org::puremvc::perl5::utilities::statemachine::FSMInjector');
  is(defined $fsm_injector->{fsm}, 1, 'Expecting defined $fsm_injector->{fsm} to be 1');
  is(ref $fsm_injector->{fsm}, "HASH", 'Expecting $fsm_injector->{fsm} to be "HASH"');
  is(scalar(keys %{$fsm_injector->{fsm}}), 2, 'Expecting scalar(keys %{$fsm_injector->{fsm}}) to be 2');
  is(exists $fsm_injector->{fsm}->{initial}, 1, 'Expecting exists $fsm_injector->{fsm}->{initial} to be 1');
  is($fsm_injector->{fsm}->{initial}, "initial_state", 'Expecting $fsm_injector->{fsm}->{initial} to be "initial_state"');
  is(exists $fsm_injector->{fsm}->{state}, 1, 'Expecting exists $fsm_injector->{fsm}->{state} to be 1');
  is(ref $fsm_injector->{fsm}->{state}, "ARRAY", 'Expecting ref $fsm_injector->{fsm}->{initial} to be "ARRAY"');
  is(scalar(@{$fsm_injector->{fsm}->{state}}), 1, 'Expecting scalar(@{$fsm_injector->{fsm}->{state}}) to be 1');
  my $state = $fsm_injector->{fsm}->{state}->[0];
  is(ref $state, "HASH", 'Expecting ref $state to be "HASH"');
  is(scalar(keys %$state), 1, 'Expecting scalar(keys %$state) to be 1');
  is(exists $state->{name}, 1, 'Expecting exists $state->{name} to be 1');
  is($state->{name}, "state11", 'Expecting state11->{name} to be "state11"');

  $hash = XMLin( $fsm_xml2, 'KeyAttr' => [], 'ForceArray' => [ 'state', 'transition' ] );
  $fsm_injector = org::puremvc::perl5::utilities::statemachine::FSMInjector->new( $hash );
  is(defined $fsm_injector, 1, 'Expecting $fsm_injector to be defined');
  isa_ok($fsm_injector, 'org::puremvc::perl5::utilities::statemachine::FSMInjector');
  is(defined $fsm_injector->{fsm}, 1, 'Expecting defined $fsm_injector->{fsm} to be 1');
  is(ref $fsm_injector->{fsm}, "HASH", 'Expecting $fsm_injector->{fsm} to be "HASH"');
  is(scalar(keys %{$fsm_injector->{fsm}}), 2, 'Expecting scalar(keys %{$fsm_injector->{fsm}}) to be 2');
  is(exists $fsm_injector->{fsm}->{initial}, 1, 'Expecting exists $fsm_injector->{fsm}->{initial} to be 1');
  is($fsm_injector->{fsm}->{initial}, "initial_state", 'Expecting $fsm_injector->{fsm}->{initial} to be "initial_state"');
  is(exists $fsm_injector->{fsm}->{state}, 1, 'Expecting exists $fsm_injector->{fsm}->{state} to be 1');
  is(ref $fsm_injector->{fsm}->{state}, "ARRAY", 'Expecting ref $fsm_injector->{fsm}->{initial} to be "ARRAY"');
  is(scalar(@{$fsm_injector->{fsm}->{state}}), 3, 'Expecting scalar(@{$fsm_injector->{fsm}->{state}}) to be 3');
  $state = $fsm_injector->{fsm}->{state}->[0];
  is(ref $state, "HASH", 'Expecting ref $state to be "HASH"');
  is(scalar(keys %$state), 3, 'Expecting scalar(keys %$state) to be 3');
  is($state->{name}, "state21", 'Expecting $state->{name} to be "state21"');
  is($state->{entering}, "entering_state21", 'Expecting $state->{entering} to be "entering_state21"');
  is(ref $state->{transition}, "ARRAY", 'Expecting ref $state->{transition} to be "ARRAY"');
  is(scalar(@{$state->{transition}}), 2, 'Expecting scalar($state->{transition}) to be 2');
  my $transition = $state->{transition}->[0];
  is(ref $transition, "HASH", 'Expecting $transition to be "HASH"');
  is(scalar(keys %$transition), 2, 'Expecting scalar(keys %$transition) to be 2');
  is($transition->{action}, "transition211_action", 'Expecting $transition->{action} to be "transition211_action"');
  is($transition->{target}, "state22", 'Expecting $transition->{target} to be "state22"');
  $transition = $state->{transition}->[1];
  is(ref $transition, "HASH", 'Expecting $transition to be "HASH"');
  is(scalar(keys %$transition), 2, 'Expecting scalar(keys %$transition) to be 2');
  is($transition->{action}, "transition212_action", 'Expecting $transition->{action} to be "transition212_action"');
  is($transition->{target}, "state23", 'Expecting $transition->{target} to be "state23"');

  $state = $fsm_injector->{fsm}->{state}->[1];
  is(ref $state, "HASH", 'Expecting ref $state to be "HASH"');
  is(scalar(keys %$state), 3, 'Expecting scalar(keys %$state) to be 3');
  is($state->{name}, "state22", 'Expecting $state->{name} to be "state22"');
  is($state->{exiting}, "exiting_state22", 'Expecting $state->{exiting} to be "exiting_state22"');
  is(ref $state->{transition}, "ARRAY", 'Expecting ref $state->{transition} to be "ARRAY"');
  is(scalar(@{$state->{transition}}), 1, 'Expecting scalar($state->{transition}) to be 1');
  $transition = $state->{transition}->[0];
  is(ref $transition, "HASH", 'Expecting $transition to be "HASH"');
  is(scalar(keys %$transition), 2, 'Expecting scalar(keys %$transition) to be 2');
  is($transition->{action}, "transition221_action", 'Expecting $transition->{action} to be "transition221_action"');
  is($transition->{target}, "state23", 'Expecting $transition->{target} to be "state23"');

  $state = $fsm_injector->{fsm}->{state}->[2];
  is(ref $state, "HASH", 'Expecting ref $state to be "HASH"');
  is(scalar(keys %$state), 3, 'Expecting scalar(keys %$state) to be 3');
  is($state->{name}, "state23", 'Expecting $state->{name} to be "state23"');
  is($state->{changed}, "changed_state23", 'Expecting $state->{changed} to be "changed_state23"');
  is(ref $state->{transition}, "ARRAY", 'Expecting ref $state->{transition} to be "ARRAY"');
  is(scalar(@{$state->{transition}}), 1, 'Expecting scalar($state->{transition}) to be 1');
  $transition = $state->{transition}->[0];
  is(ref $transition, "HASH", 'Expecting $transition to be "HASH"');
  is(scalar(keys %$transition), 2, 'Expecting scalar(keys %$transition) to be 2');
  is($transition->{action}, "transition231_action", 'Expecting $transition->{action} to be "transition231_action"');
  is($transition->{target}, "state21", 'Expecting $transition->{target} to be "state21"');

}

#**********************
sub testMethods {

  print "########## testMethods\n";

  my $hash = XMLin( $fsm_xml2, 'KeyAttr' => [], 'ForceArray' => [ 'state', 'transition' ] );
  my $fsm_injector = org::puremvc::perl5::utilities::statemachine::FSMInjector->new( $hash );
  
  can_ok($fsm_injector, "inject");
  can_ok($fsm_injector, "states");
  can_ok($fsm_injector, "createState");
  can_ok($fsm_injector, "isInitial");

}

#**********************
sub testIsInitial {

  print "########## testIsInitial\n";

  my $hash = XMLin( $fsm_xml2, 'KeyAttr' => [], 'ForceArray' => [ 'state', 'transition' ] );
  my $fsm_injector = org::puremvc::perl5::utilities::statemachine::FSMInjector->new( $hash );
  my $state1 = org::puremvc::perl5::utilities::statemachine::State->new("state1");
  is($fsm_injector->isInitial($state1->{name}), "", 'Expecting $fsm_injector->isInitial($state1->{name}) to be ""');

  my $initial_state = org::puremvc::perl5::utilities::statemachine::State->new("initial_state");
  is($fsm_injector->isInitial($initial_state->{name}), 1, 'Expecting $fsm_injector->isInitial($initial_state->{name}) to be 1');

}

#**********************
sub testCreateState {

  print "########## testCreateState\n";

  my $hash = XMLin( $fsm_xml2, 'KeyAttr' => [], 'ForceArray' => [ 'state', 'transition' ] );
  my $fsm_injector = org::puremvc::perl5::utilities::statemachine::FSMInjector->new( $hash );
  my $state = $fsm_injector->createState($fsm_injector->{fsm}->{state}->[0]);

  isa_ok($state, 'org::puremvc::perl5::utilities::statemachine::State');
  is($state->{name}, "state21", 'Expecting $state->{name} to be "state21"');
  is($state->{entering}, "entering_state21", 'Expecting $state->{entering} to be "entering_state21"');
  is(ref $state->{transitions}, "HASH", 'Expecting ref $state->{transitions} to be "HASH"');
  is(scalar(keys %{$state->{transitions}}), 2, 'Expecting scalar(keys %{$state->{transitions}}) to be 2');

  my $transition = $fsm_injector->{fsm}->{state}->[0]->{transition}->[0];
  is($state->getTarget($transition->{action}), $transition->{target}, 'Expecting $state->getTarget($transition->{action}) to be $transition->{target}');

  $transition = $fsm_injector->{fsm}->{state}->[0]->{transition}->[1];
  is($state->getTarget($transition->{action}), $transition->{target}, 'Expecting $state->getTarget($transition->{action}) to be $transition->{target}');

}

#**********************
sub testStates {

  print "########## testStates\n";

  my $hash = XMLin( $fsm_xml2, 'KeyAttr' => [], 'ForceArray' => [ 'state', 'transition' ] );
  my $fsm_injector = org::puremvc::perl5::utilities::statemachine::FSMInjector->new( $hash );
  my $states = $fsm_injector->states();

  is(ref $states, "ARRAY", 'Expecting ref $states to be "ARRAY"');
  is(scalar(@$states), 3, 'Expecting scalar(@$states) to be 3');

  for (my $i = 0; $i < 3; ++$i) {
    isa_ok($states->[$i], 'org::puremvc::perl5::utilities::statemachine::State');
    is($states->[$i]->{name}, "state2" . ($i+1), 'Expecting $states->[' . $i . ']->{name} to be "state2' . ($i+1) . '"');
  }
}

#**********************
sub testInject {

  print "########## testInject\n";

  my $facade = org::puremvc::perl5::patterns::facade::Facade->getInstance();
  my $hash = XMLin( $fsm_xml2, 'KeyAttr' => [], 'ForceArray' => [ 'state', 'transition' ] );
  my $fsm_injector = org::puremvc::perl5::utilities::statemachine::FSMInjector->new( $hash );
  
  $fsm_injector->inject();
  my $mediator = $facade->retrieveMediator( org::puremvc::perl5::utilities::statemachine::StateMachine::NAME );
  isa_ok($mediator, 'org::puremvc::perl5::utilities::statemachine::StateMachine');
  
}

#**********************
#**********************
1;