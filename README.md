# perl5-to-ruby
Extremely dirty perl5 to ruby syntax translation.

They said it couldn't be done.  They were right.

## Motivation
Maybe you have some perl modules you want to convert to ruby.  The best way is probably a ground-up rewrite.  But who has time for that nonsense?  At first i wrote a cheapy script using a few dozen regexes to save myself from having to perform search&replaces in my editor.  That helped, but only got me a tiny fraction of the way there.

The internet was not my friend -  search "Perl Cannot Be Parsed".  Finally i found PPI and tried hacking together a super dirty syntax translator.

## Criticism
* Even if you could translate Perl to Ruby, you shouldn't.
* Output from this tool is either trash, or not the Ruby way, or both.

## Expected use model
_Follow these steps in no particular order_
* Run working/clean Perl code through <tt>p2r</tt>
* Translate into completely broken half-perl/half-ruby syntax
* Run <tt>ruby -c</tt> on the resulting mess, marvel at the reduction in syntax errors
* Perform tons of manual cleanup on the ruby code
* Write tests and make sure the ruby code does the same thing as the perl code.
* Curse yourself for not doing a complete rewrite

## What p2r does
* reformats tokens
* comments out pod blocks
* basic regex/tr handling
* conditional reformatting

## What p2r does not do
* Idiomatic conversions
* Anything remotely complicated
* Produce working ruby code for all but the simplest of testcases

## Requirements

ruby, rake, perl, prove

Tested with perl 5.18, ruby 2.1.5 on Linux Mint Debian Edition v1

## Known to be broken

* <tt>BEGIN { }</tt> block output is not formatted correctly
* single-line if/unless statements are broken
* <tt>print $FH "string"</tt>
* c-style for-loops <tt>for ($x=1;$x<100;$x++) {}</tt>, still unclear how to map to something ruby-like
