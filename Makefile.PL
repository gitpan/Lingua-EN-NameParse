use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile
(
   'VERSION_FROM'    => 'NameParse.pm',
   'clean'           =>
   {
      'FILES'        => 'blib/* Makefile MANIFEST Lingua-EN-NameParse-*'
   },
   'dist'            =>
   {
      'COMPRESS'     => 'gzip',
      'SUFFIX'       => 'gz'
   },
   'DISTNAME'        => 'Lingua-EN-NameParse',

   ( $] >= 5.005 ?
      (
          ABSTRACT => 'Manipulate peoples names, titles and initials',
          AUTHOR   => 'Kim Ryan <kimryan@cpan.org>',
      ) : ()
   ),

   'NAME'            => 'Lingua::EN::NameParse',
   'PM'              =>
   {
      'NameParse.pm'   => '$(INST_LIBDIR)/NameParse.pm',
      'NameGrammar.pm' => '$(INST_LIBDIR)/NameGrammar.pm',

   },
   'PREREQ_PM'       =>
   {
      'Parse::RecDescent' => 0,
   }
);
