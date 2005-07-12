#------------------------------------------------------------------------------
# Test script for Lingua::EN::NameParse.pm
# Author : Kim Ryan
#------------------------------------------------------------------------------

use strict;
use Test::Simple tests => 11;
use Lingua::EN::NameParse qw(clean case_surname);


my $input;

# Test case_surname subroutine
$input = "BIG BROTHER & THE HOLDING COMPANY";
ok(&case_surname($input) eq 'Big Brother & The Holding Company','case_surname');

my %args =
(
  salutation      => 'Dear',
  sal_default     => 'Friend',
  auto_clean      => 1,
  force_case      => 1,
  initials        => 3,
  allow_reversed  => 1,
  joint_names     => 1,
  extended_titles => 1

);

my $name = new Lingua::EN::NameParse(%args);

# Test captialization of Mac prefix exceptions
$input = "MR AB MACHLIN";
$name->parse($input);
ok( $name->case_all eq 'Mr AB Machlin','Mac prefix exception');

# Test force casing
$input = "MR AB MACHLIN & JANE O'BRIEN";
$name->parse($input);
ok( $name->case_all eq "Mr AB Machlin & Jane O'Brien" ,'force casing');

# Test salutation
$input = "DR. A.B.C. FEELGOOD";
$name->parse($input);
ok( $name->salutation eq 'Dear Dr. Feelgood' ,'salutation');

# Test default salutation
$input = "john smith";
$name->parse($input);
ok( $name->salutation eq 'Dear Friend' ,'default salutation');

# Test component extraction
$input = "Estate Of The Late Lieutenant Colonel AB Van Der Heiden Jnr";
$name->parse($input);
my %comps = $name->case_components;
ok ( ($comps{precursor} eq 'Estate Of The Late' and
   $comps{title_1} eq 'Lieutenant Colonel' and
   $comps{initials_1} eq 'AB' and
   $comps{surname_1} eq 'Van Der Heiden' and
   $comps{suffix} eq 'Jnr'),
   'component extraction');

# Test properties
$input = "m/s de de silva";
$name->parse($input);
my %props = $name->properties;
ok ( ($props{number} == 1 and $props{type} eq 'Mr_A_Smith'),'properties');

# Test non matching
$input = "Prof A Brain & Associates";
$name->parse($input);
%props = $name->properties;
ok( $props{non_matching} eq '& Associates','non matching');

# Test cleaning
$input = '   Bad Na89me!';
ok( &clean($input) eq 'Bad Name','cleaning');

# Test reverse order names
$input = "de silva, m/s de";
$name->parse($input);
%props = $name->properties;
ok ( $props{type} eq 'Mr_A_Smith','reverse order'); 

my $lc_prefix = 1;
# Test lower casing of surname prefix
ok( &case_surname("DE SILVA-O'SULLIVAN",$lc_prefix) eq "de Silva-O'Sullivan" ,'lower casing of surname prefix');




