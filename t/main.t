#------------------------------------------------------------------------------
# Test script for Lingua::EN::NameParse.pm 
#                                            
# Author: Kim Ryan (kimaryan@ozemail.com.au) 
# Date  : 1 May 1999                         
#------------------------------------------------------------------------------

use strict;
use Lingua::EN::NameParse qw(clean case_surname);

# We start with some black magic to print on failure.

BEGIN { print "1..11\n"; }

# Main tests

my $input;

# Test case_surname subroutine
$input = "BIG BROTHER & THE HOLDING COMPANY";
print &case_surname($input) eq 'Big Brother & The Holding Company'
  ? "ok 1\n" : "not ok 1\n";
  
my %args = 
(
  salutation     => 'Dear',
  sal_default    => 'Friend',
  auto_clean     => 1,
  force_case     => 1,
  initials       => 3,
  allow_reversed => 1  
);

my $name = new Lingua::EN::NameParse(%args); 

# Test captialization of Mac prefix exceptions
$input = "MR AB MACHLIN";
$name->parse($input);
print $name->case_all eq 'Mr AB Machlin' ? "ok 2\n" : "not ok 2\n";


# Test force casing
$input = "MR AB MACHLIN & JANE O'BRIEN";
$name->parse($input);
print $name->case_all eq "Mr AB Machlin & Jane O'Brien" ? "ok 3\n" : "not ok 3\n";

# Test salutation
$input = "DR. A.B.C. FEELGOOD";
$name->parse($input);
print $name->salutation eq 'Dear Dr. Feelgood' ? "ok 4\n" : "not ok 4\n";

# Test default salutation
$input = "john smith";
$name->parse($input);
print $name->salutation eq 'Dear Friend' ? "ok 5\n" : "not ok 5\n";

# Test component extraction
$input = "Estate Of The Late Lieutenant Colonel AB Van Der Heiden Jnr";
$name->parse($input);
my %comps = $name->case_components;
if ( $comps{precursor} eq 'Estate Of The Late' and 
   $comps{title_1} eq 'Lieutenant Colonel' and 
   $comps{initials_1} eq 'AB' and
   $comps{surname_1} eq 'Van Der Heiden' and
   $comps{suffix} eq 'Jnr' ) 
{
   print "ok 6\n";   
}
else
{
   print "not ok 6\n";  
}

# Test properties
$input = "m/s de de silva";
$name->parse($input);
my %props = $name->properties;
if ( $props{number} == 1 and $props{type} eq 'Mr_A_Smith' )
{
	print "ok 7\n";
}
else
{
	print "not ok 7\n";
}

# Test non matching 
$input = "Prof A Brain & Associates";
$name->parse($input);
%props = $name->properties;
print $props{non_matching} eq '& Associates' ? "ok 8\n" : "not ok 8\n";
      
# Test cleaning
$input = '   Bad Na89me!';
print &clean($input) eq 'Bad Name' ? "ok 9\n" : "not ok 9\n";

# Test reverse order names
$input = "de silva, m/s de";
$name->parse($input);
%props = $name->properties;
if ( $props{type} eq 'Mr_A_Smith' )
{
	print "ok 10\n";
}
else
{
	print "not ok 10\n";
}

my $lc_prefix = 1;
# Test lower casing of surname prefix
print &case_surname("DE SILVA-MACNAY",$lc_prefix) eq 'de Silva-MacNay' ?  "ok 11\n" : "not ok 11\n";




