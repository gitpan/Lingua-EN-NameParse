=head1 NAME

Lingua::EN::NameParse - routines for manipulating a persons name

=head1 SYNOPSIS

   use Lingua::EN::NameParse qw(clean case_surname);

   my %args = 
   (
      salutation  => 'Dear',
      sal_default => 'Friend',
      auto_clean  => 1,
      force_case  => 1  
   );

   my $name = new Lingua::EN::NameParse(%args); 

   $name->parse("MR AC DE SILVA");

   %my_name = $name->components;
   $surname = $my_name{surname_1};

   $correct_casing = $name->case_all;

   %name = $name->case_components;

   $correct_casing = &case_surname("DE SILVA-MACNAY");

   $good_name = &clean("Bad Na9me");

   $name->salutation;

   %my_properties = $name->properties;
   $number_surnames = $my_properties{number};
   $bad_input = $my_properties{non_matching};


=head1 REQUIRES

Perl, version 5.001 or higher and Parse::RecDescent


=head1 DESCRIPTION


This module takes as input a person or persons name in 
free format text such as,

    Mr AB & M/s CD MacNay-Smith
    MR J.L. D'ANGELO
    Estate Of The Late Lieutenant Colonel AB Van Der Heiden

and attempts to parse it. If successful, the name is broken
down into components and useful functions can be performed such as :

   converting upper or lower case values to name case (Mr AB MacNay   )
   creating a personalised greeting or salutation     (Dear Mr MacNay )
   extracting the names individual components         (Mr,AB,MacNay   )
   determining the type of format the name is in      (Mr_A_Smith     )


If the name cannot be parsed you have the option of cleaning the name
of bad characters, or extracting any portion that was parsed and the 
portion that failed.

This module can be used for analysing and improving the quality of
lists of names.


=head1 DEFINITIONS 
 

The following terms are used by NameParse to define the components 
that can make up a name.

   Precursor   - Estate of (The Late) ...
   Title       - Mr, Ms., Sir, Dr ...
   Conjunction - word to separate names or initials, such as "And"
   Initials    - 1-3 letters, each with an optional space and/or dot
   Surname     - De Silva, Van Der Heiden, MacNay-Smith, O'Reilly ...

Refer to the component grammar defined within the code  for a complete
list of combinations. 

'Name casing' refers to the correct use of upper and lower case letters 
in peoples names, such as Mr AB McNay. 

To describe the formats supported by NameParse, a short hand representation
of the name is used. The following formats are currently supported :

   Mr_A_Smith_&_Ms_B_Jones
   Mr_&_Ms_A_&_B_Smith
   Mr_A_&_Ms_B_Smith
   Mr_&_Ms_A_Smith
   Mr_A_&_B_Smith
   Mr_A_Smith
   A_Smith


Precursors are only applied to the 'Mr_A_Smith' and 'A_Smith' formats

=head1 METHODS

=head2 new

The C<new> method creates an instance of a name object and sets up
the grammar used to parse names. This must be called before any of the
following methods are invoked. Note that the object only needs to be
created once, and can be reused with new input data.

Setup options may be defined in a hash that is passed as an optional argument
to the C<new> method.

   my %args = 
   (
      salutation  => 'Dear',
      sal_default => 'Friend',
      auto_clean  => 1,
      force_case  => 1  
   );

   my $name = new Lingua::EN::NameParse(%args); 


=head3 force_case

This option will force the C<case_all> method to name case the entire input
string, including any unmatched sections that failed parsing. For example, in 
"MR A JONES & ASSOCIATES", "& ASSOCIATES" will also be name cased. The casing
rules for unmatched sections are the same as for surnames. This is usually
the best option, although any initials in the unmatched section will not
be correctly cased. This option is useful when you know you data has invalid 
names, but you cannot filter out or reject them.


=head3 auto_clean

When this option is set, any call to the C<parse> method that fails will 
attempt to 'clean' the name and then reparse it. See the C<clean> method for 
details. This is useful for dirty data with embedded unprintable or non 
alphabetic characters. 
  

=head3 salutation

The option defines the salutation word, such as "Dear" or "Greetings". It
must be defined if you are planning to use the C<salutation> method.

=head3 sal_default 

This option defines the  defaulting word to substitute for the title and
surname(s), when parsing fails to identify them. It is also used when a
precursor occurs. Examples are "Friend" or "Member".It must be defined if 
you are planning to use the C<salutation> method. If an '&' or 'and' occurs
in the unmatched section then it is assumed that we are dealing with more than
one person, and an 's' is appended to the defaulting word.


=head2 parse

    $name->parse("MR AC DE SILVA");

The C<parse> method takes a single parameter of a text string
containing a name. It attempts to parse the name and break it down
into the components described above. This step is a pre-requisite 
for the following functions.

If the name was parsed successfully, a 0 is returned, otherwise a 1.


=head2 case_all

    $correct_casing = $name->case_all;

The C<case_all> method converts the first letter of each component to
capitals and the remainder to lower case, with the following exceptions-

   initials remain capitalised
   surnames such as MacNay-Smith, O'Brien and Van Der Heiden are observed

A complete definition of the capitalising rules can be found by studying
the component grammar defined within the code.

The method returns the entire cased name as text.


=head2 case_components

   %my_name = $name->components;
   $cased_surname = $my_name{surname_1};


The C<case_components> method  does the same thing as the C<case_all> method,
but returns the name cased components in a hash. The following keys are used
for each component-

   precursor
   title_1
   title_2
   initials_1
   initials_2
   conjunction_1
   conjunction_2
   surname_1
   surname_2

Entries only occur in the hash for each component that the currently parsed
name has, meaning there are no keys with undefined values.

=head2 components

   %name = $name->components;
   $surname = $my_name{surname_1};

The C<components> method  does the same thing as the C<case_components> method,
but each component is returned as it appears in the input string, with no case
conversion.

=head2 case_surname

   $correct_casing = &case_surname("DE SILVA-MACNAY");

C<case_surname> is a stand alone function that does not require a name
object. The input is a text string and the output is a string converted to
the format for surnames.

This function is useful when you know you are only dealing with names that
do not have initials like "Mr John Jones". It is much faster than the case_all 
method,  but does not understand context, and cannot detect errors on strings
that are not personal names.


=head2 salutation

The C<salutation> method converts a name into a personal greeting,
such as "Dear Mr & Mrs O'Brien". 

If an error is detected during parsing, such as with the name
"AB Smith & Associates", the title (if it occurs) and the surname(s) are
replaced with a default word like "Friend" or "Member". If the input string
contains a conjunction, an 's' is added to the default.

If the name contains a precursor, a default salutation is also produced.
  

=head2 clean

   $good_name = &clean("Bad Na9me");

C<clean> is a stand alone function that does not require a name object. 
The input is a text string and the output is the string with:

   all repeating spaces removed
   all characters not in the set (A-Z a-z - ' , . &) removed


=head2 properties

The C<properties> method return several properties of then name as a hash.

=head3 type

The type of format a name is in, as one of the following strings: 

   Mr_A_Smith_&_Ms_B_Jones
   Mr_&_Ms_A_&_B_Smith
   Mr_A_&_Ms_B_Smith
   Mr_&_Ms_A_Smith
   Mr_A_&_B_Smith
   Mr_A_Smith
   A_Smith
   unknown

=head3 number

Returns the number of surnames found in the input strings. 
Unknown name types have a number of 0. 

=head3 non_matching

Returns any unmatched section that was found.


=head1 LIMITATIONS

The huge number of character combinations that can form a valid names makes
it is impossible to correctly identify them all. Firstly, there are many 
ambiguities, which have no right answer.

   Macbeth or MacBeth, are both valid spellings
   Is ED WOOD E.D. Wood or Edward Wood
   Is 'Mr Rapid Print' a name or a company

One approach is to have large lookup files of names and words, statistical rules
and fuzzy logic to attempt to derive context. This approach gives high levels of 
accuracy but uses a lot of your computers time and resources.

NameParse takes the approach of using a limited set of rules, based on the
formats that are commonly used by business to represent peoples names. This
gives us fairly high accuracy, with acceptable speed and program size.

NameParse will accept names form many countries, like Van Der Heiden,
De La Mare and Le Fontain. Having said that, it is still biased toward English,
because the precursors, titles and conjunctions are based on English usage. 

Names with two or more words, but no separating hyphen are not recognized.
This is a real quandary as Indian, Chinese and other names can have several 
components. If these are allowed for, any component after the surname
will also be picked up. For example in "Mr AB Jones Trading As Jones Pty Ltd" 
will return a surname of "Jones Trading".

Because of the large combination of possible names defined in the grammar, the
program is not very fast, except for the more limited case_surname subroutine.
See the "Future Directions" section for possible speed ups.


=head1 REFERENCES

"The Wordsworth Dictionary of Abbreviations & Acronyms" (1997)

Australian Standard AS4212-1994 "Geographic Information Systems - 
Data Dictionary for transfer of street addressing information"


=head1 FUTURE DIRECTIONS

   Add more formats (John_A_Smith...)
   Allow for a user defined file of local spellings, like duPont, MacHado etc
   Allow for user control over prefix capitalization, (le or Le)
   Add filtering of very long names
   Add diagnostic messages explaining why parsing failed
   Add transforming methods to do things like remove dots from initials
   Add suffixes like Senior, Jnr, IV, "The Third'
   Add awards like OBE, PhD, BSc ...
   Try to derive gender (Mr... is male, Ms, Mrs... is female)

Let the user select what level of complexity of grammar they need for
their data. For example, if you know  most of your names are in a "John Smith"
format, you can avoid the ambiguity between two letter given names and 
initials. Using a limited grammar subset will also be much faster.

Define grammar for other languages. Hopefully, all that would be needed is
to specify a new module with its own grammar, and inherit all the existing
methods. I don't have the knowledge of the naming conventions for non-english 
languages.


=head1 TO DO

Add regression tests for all combinations of each component


=head1 BUGS


=head1 CHANGES

0.01 25 Apr 1999: First Release

0.02 01 May 1999: Added test script, converted source to Unix format

0.03 02 May 1999: Altered output of test script to work with Test::Harness
                  Modified &clean to remove single leading or trailing space

0.04 16 May 1999: Added test script for rule ordering
                  Added more titles, improved documentation
                  

=head1 COPYRIGHT

Copyright (c) 1999 Kim Ryan. All rights reserved.
This program is free software; you can redistribute it 
and/or modify it under the terms of the Perl Artistic License
(see http://www.perl.com/perl/misc/Artistic.html).



=head1 AUTHOR

NameParse was written by Kim Ryan <kimaryan@ozemail.com.au> in 1999.
Thanks to all the people who provided ideas and suggestions, including -

   QM Industries <http://www.qmi.com.au>
   Damian Conway <damian@cs.monash.edu.au> author of Parse::RecDescent
   <mark.summerfield@chest.ac.uk>, author of Text::NameCase, 
   Ron Savage <rpsavage@ozemail.com.au>
   <alastair@calliope.demon.co.uk>

=cut

#------------------------------------------------------------------------------

package Lingua::EN::NameParse;

use Parse::RecDescent;
use strict;

use Exporter;
use vars qw (@ISA @EXPORT_OK $VERSION);

$VERSION   = '0.04';
@ISA       = qw(Exporter);
@EXPORT_OK = qw(&clean &case_surname);

#------------------------------------------------------------------------------
# This section contains the grammar for defining valid names. Note that parsing
# is done depth first, meaning match the shortest string first. To avoid
# premature matches, when one rule is a sub set of another longer rule, it 
# must appear after the longer rule. See the Parse::RecDescent documentation
# for more details.


# Rules that define valid orderings of a names components

my $rules = q{
   
full_name :

   # A (?) refers to an optional component, occurring 0 or more times.
   # Optional items are returned as an array, which for our case will
   # always consist of one element, when they exist. 

   title initials surname conjunction title initials surname non_matching(?)
   {
      # block of code to define actions upon successful completion of a
      # 'production' or rule

      # Two separate people
      $return =
      {
         # Parse::RecDescent lets you return a single scalar, which we use as
         # an anonymous hash reference
         title_1       => $item[1],
         initials_1    => $item[2],
         surname_1     => $item[3],
         conjunction_1 => $item[4],
         title_2       => $item[5],
         initials_2    => $item[6],
         surname_2     => $item[7],
         non_matching  => $item[8][0],
         number        => 2,
         type          => 'Mr_A_Smith_&_Ms_B_Jones'
      }
   }
   |

   title initials conjunction initials surname non_matching(?)
   {
      # Two related people, shared title, separate initials, 
      # shared surname. Example, father and son, sisters
      $return =
      {
         title_1       => $item[1],
         initials_1    => $item[2],
         conjunction_1 => $item[3],
         initials_2    => $item[4],
         surname_1     => $item[5],
         non_matching  => $item[6][0],
         number        => 2,
         type          => 'Mr_A_&_B_Smith'
      }
   }
   |

   title conjunction title initials conjunction initials surname non_matching(?)
   {
      # Two related people, own initials, shared surname

      $return =
      {
         title_1       => $item[1],
         conjunction_1 => $item[2],
         title_2       => $item[3],
         initials_1    => $item[4],
         conjunction_2 => $item[5],
         initials_2    => $item[6],
         surname_1     => $item[7],
         non_matching  => $item[8][0],
         number        => 2,
         type          => 'Mr_&_Ms_A_&_B_Smith'
      }
   }
   |

   title initials conjunction title initials surname non_matching(?)
   {
      # Two related people, own initials, shared surname
      $return =
      {
         title_1       => $item[1],
         initials_1    => $item[2],
         conjunction_1 => $item[3],
         title_2       => $item[4],
         initials_2    => $item[5],
         surname_1     => $item[6],
         non_matching  => $item[7][0],
         number        => 2,
         type          => 'Mr_A_&_Ms_B_Smith'
      }
   }
   |

   title conjunction title initials surname non_matching(?)
   {
      # Two related people, shared initials, shared surname
      $return =
      {
         title_1       => $item[1],
         conjunction_1 => $item[2],
         title_2       => $item[3],
         initials_1    => $item[4],
         surname_1     => $item[5],
         non_matching  => $item[6][0],
         type          => 'Mr_&_Ms_A_Smith'
      }
   }
   |

   precursor(?) title initials surname non_matching(?)
   {
      $return =
      {
         precursor     => $item[1][0],
         title_1       => $item[2],
         initials_1    => $item[3],
         surname_1     => $item[4],
         non_matching  => $item[5][0],
         number        => 1,
         type          => 'Mr_A_Smith'
      }
   }
   |

   precursor(?) initials surname non_matching(?)
   {
      $return =
      {
         precursor     => $item[1][0],
         initials_1    => $item[2],
         surname_1     => $item[3],
         non_matching  => $item[4][0],
         number        => 1,
         type          => 'A_Smith',
      }
   }
   |
    
   non_matching(?)
   {
      $return =
      {
         non_matching  => $item[1][0],
         number        => 0,
         type          => 'unknown'
      }
   }
};

#------------------------------------------------------------------------------
# Individual components that a name can be composed from. Components are 
# expressed as literals or Perl regular expressions.

my $components = q{
   
precursor : /Estate Of (The Late )?/i

title :

   /Mr\.? /i           |
   /Mrs\.? /i          |
   /Ms\.? /i           |
   /M(iss|\/s)\.? /i   |
   /Mme\.? /i          |   # Madame

   /Messrs /i          |   # plural or Mr
   /Mister /i          |
   /Mast(\.|er)? /i    |    
   /Ms?gr\.? /i        |   # Monsignor

   /Sir /i             |
   /Lord /i            |
   /Lady /i            |
   /Madam(e)? /i       |
   /Dame /i            |

   # Medical
   /Dr\.? /i           |
   /Doctor /i          |
   /Sister /i          |
   /Matron /i          |
   
   # Legal
   /J\.? /             |   # Judge
   /Judge /i           |   
   /Justice /i         |   

   # Police
   /Det\.? /i          |      
   /Insp\.? /i         |

   # Military
   /Capt(\.|ain)? /i             |      
   /Cdr\.? /i                    |   # Commander, Commodore
   /Gen(\.|eral)? /i             | 
   /Sgt\.? /i                    |
   /Sargent /i                   |
   /(Air )?Commodore /i          |
   /Air Marshall /i              |
   /Lieutenant (Colonel )?/i     |
   /(Lt|Leut|Lieut)\.? /i        |
   /Colonel /i                   |
   /Lt\.? ((Col|Gen|Cdr)\. )?/   | 
   /Maj(\.|or)? (Gen(\.|eral)? )? /i | 

   # Religous
   /Rabbi /i                     |
   
   /Brother /i                   |
   /Father /i                    |
   /Chaplain /i                  |
   /Pastor /i                    |
   /Bishop /i                    |
   /Mother (Superior )?/i        |
   /[Mt|V]? Revd?\.? /i          |  
   /[Most|Very]? Rever[e|a]nd /i |
   
   # Other
   /Prof(\.|essor)? /i |
   /Ald(\.|erman)? /i
   


conjunction  : /And |& /i

initials     : 
    /([A-Z] ){1,3}/i |
    /([A-Z]){1,3} /i |
    /([A-Z]\.){1,3} /i


surname : sub_surname second_name(?)
{ 
   $return = "$item[1]" 
}

sub_surname : prefix(?) name
{
   # To prevent warning when compiling with the -w switch,
   # do not return uninitialized variables.
   if ( $item[1][0] )
   {
      $return = "$item[1][0]$item[2]";
   }
   else
   {
      $return = $item[2];
   }
}

second_name : '-' sub_surname
{
   if ( $item[1] and $item[2] )
   {
      $return = "$item[1]$item[2]"
   }
}


# Patronymic, place name and other surname prefixes
prefix:

   /[A|E]l /i      |      # Arabic, Greek, 
   /Ap /i          |      # Welsh
   /Ben /i         |      # Hebrew, NOTE is this normally hyphenated??


   /Dell([a|e|'])? /i |   # ITALIAN
   /Del /i         |      
   /De (La )?/i    |      
   /D[a|i|u|'] /i  |      
   /L[a|e|o] /i    |      

   /[O|L]'/i       |      # O'=Irish, L'=French
   /St\.? /i       |      # abbrevation for Saint

   /Den /i         |      # DUTCH
   /Von (Der )?/i  |  
   /Van (De(n|r)? )?/i


name: /[A-Z]{2,} ?/i       


non_matching: /.*/

};
#------------------------------------------------------------------------------
# Hash of of lists, indicating the order that name components are assembled in.
# Used by the case_all and salutation methods.

my %component_order=
(
   'Mr_A_Smith_&_Ms_B_Jones' => ['title_1','initials_1','surname_1','conjunction_1','title_2','initials_2','surname_2'],
   'Mr_&_Ms_A_&_B_Smith' => ['title_1','conjunction_1','title_2','initials_1','conjunction_1','initials_2','surname_1'],
   'Mr_A_&_Ms_B_Smith'   => ['title_1','initials_1','conjunction_1','title_2','initials_2','surname_1'],
   'Mr_&_Ms_A_Smith'     => ['title_1','conjunction_1','title_2','initials_1','surname_1'],
   'Mr_A_&_B_Smith'      => ['title_1','initials_1','conjunction_1','initials_2','surname_1'],
   'Mr_A_Smith'          => ['precursor','title_1','initials_1','surname_1'],
   'A_Smith'             => ['precursor','initials_1','surname_1']
);
#------------------------------------------------------------------------------
# Create a new instance of a name parsing object. This step is time consuming
# and should nornally only be called once in yur program. 

sub new
{
   my $class = shift;
   my %args = @_;

   my $name = {};
   bless($name,$class);

   my $grammar = $rules . $components;
   $name->{parse} = new Parse::RecDescent($grammar);

   # ADD ERROR CHECKING FOR INVALID KEYS
   my $curr_key;
   foreach $curr_key (keys %args)
   {
      if ( $curr_key eq 'salutation' or $curr_key eq 'sal_default' )
      {
         $name->{$curr_key} = &_case_word($args{$curr_key});
      }
      else
      {
         $name->{$curr_key} = $args{$curr_key};
      }
   }
   return ($name);
}
#------------------------------------------------------------------------------
sub parse
{
   my $name = shift;
   my ($input_string) = @_;

   chomp($input_string);
   $name = &_assemble($name,$input_string);
   &_validate($name);    

   if ( $name->{error} and $name->{auto_clean} )
   {
      $input_string = &clean($input_string);
      $name = &_assemble($name,$input_string);
      &_validate($name);    
   }

   return($name,$name->{error});
}
#------------------------------------------------------------------------------
# Clean the input string. Can be called as a stnad alone function.
sub clean
{
   my ($input_string) = @_;

   # remove illegal characters
   $input_string =~ s/[^a-z\-\'\.,&\/ ]//ig;
   
   # remove repeating spaces
   $input_string =~ s/( ) +/$1/ig; 

   # remove any remaining leading or trailing space
   $input_string =~ s/^ //i; 
   $input_string =~ s/ $//i;
   
   return($input_string);
}
#------------------------------------------------------------------------------
sub components
{
   my $name = shift;
   if ( $name->{components} )
   {
      return(%{ $name->{components} });
   }
   else
   {
      return('');
   }
}
#------------------------------------------------------------------------------
# Apply correct capitalisation to each component of a person's name

sub case_components
{
   my $name = shift;

   unless ( $name->{properties}{type} eq 'unknown'  )
   {
      my %orig_components = $name->components;

      my ($curr_key,%cased_components);
      foreach $curr_key ( keys %orig_components )
      {
         my $cased_value;
         if ( $curr_key =~ /initials/ )
         {
            $cased_value = uc($orig_components{$curr_key});
         }
         elsif ( $curr_key =~ /surname/ )
         {
            $cased_value = &case_surname($orig_components{$curr_key});
         }
         else
         {
            $cased_value = &_case_word($orig_components{$curr_key});
         }

         $cased_components{$curr_key} = $cased_value;
      }
      return(%cased_components);
   }
}
#------------------------------------------------------------------------------
# Apply correct capitalisation to a person's entire name

sub case_all
{
   my $name = shift;

   my @cased_name;

   unless ( $name->{properties}{type} eq 'unknown'  )
   {
      my %component_vals = $name->case_components;
      my @order = @{ $component_order{$name->{properties}{type} } };

      my $component;
      foreach $component ( @order )
      {
         # As some components (eg precursors) are optional, they will appear 
         # in the order array but may or may not have have a value, so check 
         # for undefined values
         if ( $component_vals{$component} )
         {
            push(@cased_name,$component_vals{$component});
         }
      }
   }

   if ( $name->{error} and $name->{force_case} )
   {
      # Despite errors, try to name case non-matching section. As the format
      # of this section is unknown, surname case will provide the best
      # approximation, but still fail on initials of more than 1 letter 
      push(@cased_name,&case_surname($name->{properties}{non_matching}));
   }

   return(join(' ',@cased_name));
}
#------------------------------------------------------------------------------
# Apply correct capitalisation to a person's surname

sub case_surname
{
   my ($surname) = @_;

   # Lowercase everything
   $_ = lc($surname);  

   # Now uppercase first letter of every word. By checking on word boundaries,
   # we will account for apostrophes (D'Angelo) and hyphenated names
   s/\b(\w)/\u$1/g;  

   # Name case Macs and Mcs
   # Exclude names with 1-2 letters after prefix like Mack, Macky, Mace
   # Exclude names ending in a,c,i,o,z or j, typically Polish or Italian

   if ( /\bMac[a-z]{2,}[^a|c|i|o|z|j]\b/i  )  
   {
      s/\b(Mac)([a-z]+)/$1\u$2/ig;

      # Now correct for "Mac" exceptions
      s/MacHin/Machin/;
      s/MacHlin/Machlin/;
      s/MacHar/Machar/;
      s/MacKle/Mackle/;
      s/MacKlin/Macklin/;
      s/MacKie/Mackie/;
      s/MacQuarie/Macquarie/;

      # Portuguese
      s/MacHado/Machado/;        

      # Lithuanian
      s/MacEvicius/Macevicius/;  
      s/MacIulis/Maciulis/;  
      s/MacIas/Macias/;  
   }
   elsif ( /\bMc/i )
   {
      s/\b(Mc)([a-z]+)/$1\u$2/ig;
   }
   # Exceptions (only Celtic name ending in 'o' ?)
   s/Macmurdo/MacMurdo/;

   return($_);
}
#------------------------------------------------------------------------------
# Derive a personalised greeting from perosn's name

sub salutation
{
   my $name = shift;

   unless ( $name->{salutation} and  $name->{sal_default})
   {
      die ("No salutation word or default defined");
   }

   my @salutation;
   push(@salutation,$name->{salutation});

   if ( $name->{error} or $name->{components}{precursor} or 
      not $name->{components}{title_1} )
   {
   	# create salutation in the form: Dear Friend(s)?
      my $default = $name->{sal_default};

      # Despite an error, the presence of a conjunction probably
      # means we are dealing with 2 or more people. 
      # For example Mr AB Smith & John Jones
      if ( $name->{input_string} =~ / (And|&) /i )
      {
         $default .= 's';
      }
      push(@salutation,$default);
   }
   else
   {
   	# create salutation in the form: Dear <title(s)?> <surname(s)?>
      my %component_vals = $name->case_components;
      my @order = @{ $component_order{$name->{properties}{type} } };

      my (@cased_components,$component);
      foreach $component ( @order )
      {
         unless ( $component =~ /initial/ or not $component_vals{$component} )
         {
            push(@salutation,$component_vals{$component});
            # shared initial and surname (eg borthers), so duplicate title_1
            if ( $name->{properties}{type} eq 'Mr_A_&_B_Smith' and $component eq 'conjunction_1' )
            {
               push(@salutation,$component_vals{title_1});
            }
         }
      }
   }
   return(join(' ',@salutation));
}
#------------------------------------------------------------------------------
sub properties
{
   my $name = shift;
   return(%{ $name->{properties} });
}
#------------------------------------------------------------------------------

# PRIVATE METHODS

#------------------------------------------------------------------------------
sub _assemble
{
   my $name = shift;
   my ($input_string) = @_;

   my $parsed_name = $name->{parse}->full_name($input_string);

   $name->{input_string} = $input_string;

   # Place components into a separate hash, so they can be easily returned to
   # for the user to inspect and modify
   $name->{components} = ();

   if ( $parsed_name->{precursor} )
   {
      # For correct matching, the grammar of each component must include the
      # trailing space that separates it from any following word. This should
      # now be removed from the components, and will be restored by the
      # case_all and salutation methods, if called.
      $name->{components}{precursor} = &_trim_space($parsed_name->{precursor});
   }
   if ( $parsed_name->{title_1} )
   {
      $name->{components}{title_1} = &_trim_space($parsed_name->{title_1});
   }     
   if ( $parsed_name->{title_2} )
   {
      $name->{components}{title_2} = &_trim_space($parsed_name->{title_2});
   }
   if ( $parsed_name->{initials_1} )
   {
      $name->{components}{initials_1} = &_trim_space($parsed_name->{initials_1});
   }
   if ( $parsed_name->{initials_2} )
   {
      $name->{components}{initials_2} = &_trim_space($parsed_name->{initials_2});
   }
   if ( $parsed_name->{conjunction_1} )
   {
      $name->{components}{conjunction_1} = &_trim_space($parsed_name->{conjunction_1});
   }
   if ( $parsed_name->{conjunction_2} )
   {
      $name->{components}{conjunction_2} = &_trim_space($parsed_name->{conjunction_2});
   }
   if ( $parsed_name->{surname_1} )
   {
      $name->{components}{surname_1} = &_trim_space($parsed_name->{surname_1});
   }
   if ( $parsed_name->{surname_2} )
   {
      $name->{components}{surname_2} = &_trim_space($parsed_name->{surname_2});
   }

   $name->{properties} = ();

   $name->{properties}{non_matching}  = $parsed_name->{non_matching};
   $name->{properties}{number}        = $parsed_name->{number};
   $name->{properties}{type}          = $parsed_name->{type};


   return($name);
}
#------------------------------------------------------------------------------
sub _trim_space
{
   my ($string) = @_;
   $string =~ s/ $//;
   return($string);
}
#------------------------------------------------------------------------------

sub _validate
{
   my $name = shift;

   if ( $name->{properties}{non_matching} )
   {
      $name->{error} = 1;
   } 
   # illegal characters found
   elsif ( $name->{input_string} =~ /[^A-Za-z\-\'\.,&\/ ]/ ) 
   {
      $name->{error} = 1;
   }

   # no vowel sound in surname(s)
   elsif ( $name->{components}{surname_1} !~ /[a|e|i|o|u|y|j]|^Ng$/i )
   {
      $name->{error} = 1;
   }
   elsif ( $name->{components}{surname_2} and 
      $name->{components}{surname_2} !~ /[a|e|i|o|u|y|j]|^Ng$/i )
   {
      $name->{error} = 1;
   }
   else
   {
      $name->{error} = 0;
   }
}
#------------------------------------------------------------------------------
# Upper case first letter, lower case the rest for all words in string
sub _case_word
{
   my ($word) = @_;

   $word =~ s/(\w+)/\u\L$1/g;
   return($word);
}
#------------------------------------------------------------------------------
return(1);
