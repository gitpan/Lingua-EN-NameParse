#------------------------------------------------------------------------------
# File  : rules.t - test script for Lingua::EN::NameParse.pm
#
# Author: Kim Ryan (kimaryan@ozemail.com.au)
# Date  : 1 May 1999
#------------------------------------------------------------------------------

use strict;
use Lingua::EN::NameParse;

# We start with some black magic to print on failure.

BEGIN { print "1..12\n"; }

my $name = new Lingua::EN::NameParse;
my ($input,%props);

# Test order of rule evaluation

$input = "MR AB SMITH & MS D.E. JONES";
$name->parse($input);
%props = $name->properties;
print $props{type} eq 'Mr_A_Smith_&_Ms_B_Jones' ? "ok 1\n" : "not ok 1\n";

$input = "MR AND MRS AB & D.E. JONES";
$name->parse($input);
%props = $name->properties;
print $props{type} eq 'Mr_&_Ms_A_&_B_Smith' ? "ok 2\n" : "not ok 2\n";

$input = "MR AB AND MS D.E. JONES";
$name->parse($input);
%props = $name->properties;
print $props{type} eq 'Mr_A_&_Ms_B_Smith' ? "ok 3\n" : "not ok 3\n";

$input = "MR AND MS D.E. JONES";
$name->parse($input);
%props = $name->properties;
print $props{type} eq 'Mr_&_Ms_A_Smith' ? "ok 4\n" : "not ok 4\n";

$input = "MR AB AND D.E. JONES";
$name->parse($input);
%props = $name->properties;
print $props{type} eq 'Mr_A_&_B_Smith' ? "ok 5\n" : "not ok 5\n";

$input = "MR JOHN F KENNEDY";
$name->parse($input);
%props = $name->properties;
print $props{type} eq 'Mr_John_A_Smith' ? "ok 6\n" : "not ok 6\n";

$input = "MR TOM JONES";
$name->parse($input);
%props = $name->properties;
print $props{type} eq 'Mr_John_Smith' ? "ok 7\n" : "not ok 7\n";

$input = "MR AB JONES";
$name->parse($input);
%props = $name->properties;
print $props{type} eq 'Mr_A_Smith' ? "ok 8\n" : "not ok 8\n";

$input = "WILLIAM JEFFERSON CLINTON";
$name->parse($input);
%props = $name->properties;
print $props{type} eq 'John_Adam_Smith' ? "ok 9\n" : "not ok 9\n";

$input = "JOHN F KENNEDY";
$name->parse($input);
%props = $name->properties;
print $props{type} eq 'John_A_Smith' ? "ok 10\n" : "not ok 10\n";

$input = "TOM JONES";
$name->parse($input);
%props = $name->properties;
print $props{type} eq 'John_Smith' ? "ok 11\n" : "not ok 11\n";

$input = "AB JONES";
$name->parse($input);
%props = $name->properties;
print $props{type} eq 'A_Smith' ? "ok 12\n" : "not ok 12\n";


