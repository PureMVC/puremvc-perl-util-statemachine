#/usr/bin/perl

use lib "../lib";
use lib "../src";
use lib "./tests";

BEGIN {
  print "Content-type: text/plain; charset=iso-8859-1\n\n";
  print "#################### Tests begin\n";
}

use org::puremvc::perl5::multicore::utilities::statemachine::unittests::StateTest;
use org::puremvc::perl5::multicore::utilities::statemachine::unittests::StateMachineTest;
use org::puremvc::perl5::multicore::utilities::statemachine::unittests::FSMInjectorTest;

use Test::More;

print "#################### Tests done\n";

done_testing();


