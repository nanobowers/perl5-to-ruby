
# scalar assignment seems to work

use constant FOO1 => 11 ;
  use constant FOO2 =>12 ;
use constant FOO3=> 13 ;
use constant FOO4=>14 ;

 local $tail = 'tail';
  our $wing = 'wing';
   my $foo = "0";

$a = 1;
@abcd = qw(fee fi fo fum);
$zoot = { 'a' => "hashref_value_1\n", 'b' => "hashref_value_2\n" };
$ABCD_LENGTH = $#abcd;

# assign from list-like to array/hash.
@abcd2 = ('fee','fi','fo','fum');
%zoot2 = ( 'a' => 'b' );


## array access and length
$b = $abcd[FOO4]; ## access with constant
$b = $abcd[1];    ## access with integer
$ABCD_LENGTH = $#abcd;

## hash access
print "abc";
print $a;
print @abcd;

# working if hash is empty-assigned like this
%zz = {};
$zz{'aaaz'} = "bbbz\n";
print $zz{'aaaz'};

## variable names
$a_1 = 1;
$a_A = 1; 
$aBc = 1;
$A = 1;
$Abc = 1;
$_ = 0;
$_ = $+;

# broken : hash as comman separated list
#%yy = ('lh_key', "list-hash-value\n");
#print $yy{'lh_key'};

# working : hash as fatcomma separated list
%yy = ('fch_key' => "fatcomma-hash-value\n");
print $yy{'fch_key'};

# added support for fatcomma to string-literal
$a={ FOO=>"bar" , biz => 3};
%a=( FOO=>"bar" , BAZ => 'buz');
