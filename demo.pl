#!/usr/local/bin/perl -w

# Demo script for Lingua::EN::NameParse.pm

use Lingua::EN::NameParse qw(&case_surname &clean);

# Quick casing, no parsing or context check

$input = "DE TANGELO";
print("$input :",&case_surname($input,1),"\n\n");

my %args = 
(
   salutation  => 'Dear',
   sal_default => 'Friend',
   auto_clean  => 1,
   force_case  => 1,
   lc_prefix   => 1,
   initials    => 3  
);

my $name = new Lingua::EN::NameParse(%args); 

open(ERROR_FH,">errors.txt");
open(REPORT_FH,">report.txt");
open(EXTRACT_FH,">extract.txt");

my ($num_names,$num_errors);
while (<DATA>)
{
   chomp($_);
   $input = $_;
   $num_names++;
   $error = $name->parse($input);

   unless ( $name->{properties}{type} eq 'unknown'  )
   {
      %comps = $name->case_components;
   }
   %props = $name->properties;
   $bad_part = $props{non_matching};

   if ($error)
   {
      $num_errors++;
      printf(ERROR_FH "%-40.40s %-40.40s\n",$input,$bad_part);
   }

   if ( $props{type} eq 'Mr_A_Smith' )
   {
      # extract all single names with title and initials
      printf(EXTRACT_FH "%-40.40s %-20.20s %-3.3s %-20.20s\n",
         $input,$comps{title_1},$comps{initials_1},$comps{surname_1});
   }

   my $whole_name = $name->case_all;
   my $salutation = $name->salutation;
   printf(REPORT_FH "%-40.40s %-40.40s %-40.40s\n",$input,$whole_name,$salutation);
}
printf("BATCH DATA QUALITY: %5.2f percent\n",( 1- ($num_errors / $num_names)) *100 );

close(EXTRACT_FH);
close(ERROR_FH);
close(REPORT_FH);

#------------------------------------------------------------------------------
__DATA__
MR AB MACMURDO
LIEUTENANT COLONEL DE DE SILVA
REVERAND S.A. VON DER MERVIN SENIOR
<MR AND MRS AB & CD O'BRIEN>
MR AB AND M/S CD VAN DER HEIDEN-MACNAY
 MR AS & D.E. DE LA MARE
ESTATE OF THE LATE AB LE FONTAIN
BIG BROTHER & THE HOLDING COMPANY
MR TOM JONES
JAMES BROWN
MR AS SMI9TH
prof a.s.d. genius
