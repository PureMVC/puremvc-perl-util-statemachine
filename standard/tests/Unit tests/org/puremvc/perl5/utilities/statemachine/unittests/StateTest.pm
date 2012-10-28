package org::puremvc::perl5::utilities::statemachine::unittests::StateTest;

use strict; use warnings;

use Test::More;

BEGIN { print "############### State tests\n"; }

BEGIN { use_ok( 'org::puremvc::perl5::utilities::statemachine::State' ); }
require_ok( 'org::puremvc::perl5::utilities::statemachine::State' );

#**********************
#**********************
test();

#**********************
sub test {
  testConstructor();
  testMethods();  
  testDefineTrans();
  testRemoveTrans();
  testGetTarget();

}

#**********************
sub testConstructor {

  print "########## testConstructor\n";

  my $state = org::puremvc::perl5::utilities::statemachine::State->new("state1");
  
  is(defined $state, 1, 'Expecting $state to be defined');
  isa_ok($state, 'org::puremvc::perl5::utilities::statemachine::State');
  is($state->{name}, "state1", 'Expecting $state->{name} to be "state1"');
  is(defined $state->{entering}, "", 'Expecting $state->{entering} to be ""');
  is(defined $state->{exiting}, "", 'Expecting $state->{exiting} to be ""');
  is(defined $state->{changed}, "", 'Expecting $state->{changed} to be ""');
  is(defined $state->{transitions}, 1, 'Expecting $state->{transitions} to be 1');

  $state = org::puremvc::perl5::utilities::statemachine::State->new("state1", "entering", "exiting", "changed");
  
  is(defined $state, 1, 'Expecting $state to be defined');
  is($state->{name}, "state1", 'Expecting $state->{name} to be "state1"');
  is($state->{entering}, "entering", 'Expecting $state->{entering} to be "entering"');
  is($state->{exiting}, "exiting", 'Expecting $state->{exiting} to be "exiting"');
  is($state->{changed}, "changed", 'Expecting $state->{changed} to be "changed"');
  is(defined $state->{transitions}, 1, 'Expecting $state->{transitions} to be 1');

}

#**********************
sub testMethods {

  print "########## testMethods\n";

  my $state = org::puremvc::perl5::utilities::statemachine::State->new("state1");
  
  can_ok($state, "defineTrans");
  can_ok($state, "removeTrans");
  can_ok($state, "getTarget");

}

#**********************
sub testDefineTrans {

  print "########## testDefineTrans\n";

  my $state = org::puremvc::perl5::utilities::statemachine::State->new("state1");
  
  $state->defineTrans( "action", "target" );
  is($state->{transitions}->{"action"}, "target", 'Expecting $state->{transitions}->{"action"} to be "target"');

  # redefining same action and check still registered
  $state->defineTrans( "action", "target" );
  is($state->{transitions}->{"action"}, "target", 'Expecting $state->{transitions}->{"action"} to be "target"');

}

#**********************
sub testRemoveTrans {

  print "########## testRemoveTrans\n";

  my $state = org::puremvc::perl5::utilities::statemachine::State->new("state1");
  
  $state->defineTrans( "action", "target" );
  is($state->{transitions}->{"action"}, "target", 'Expecting $state->{transitions}->{"action"} to be "target"');

  $state->removeTrans( "action" );
  is(exists $state->{transitions}->{"action"}, "", 'Expecting exists $state->{transitions}->{"action"} to be ""');

  # test removal of non existing action does not crash
  eval { $state->removeTrans( "action1" ); };
  is($@, "", 'Expecting removal not to crash');

}

#**********************
sub testGetTarget {

  print "########## testGetTarget\n";

  my $state = org::puremvc::perl5::utilities::statemachine::State->new("state1");
  $state->defineTrans( "action", "target" );
  
  my $target = $state->getTarget( "action" );
  is($target, "target", 'Expecting $target to be "target"');

  $target = $state->getTarget( "action1" );
  is(defined $target, "", 'Expecting defined $target to be ""');

}

#**********************
#**********************
1;