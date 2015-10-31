
# scalar assignment seems to work

use constant FOO1 => 11 ;
  use constant FOO2 =>12 ;
use constant FOO3=> 13 ;
use constant FOO4=>14 ;

my $foo = "0";
$a = 1;
@abcd = qw(fee fi fo fum);
$zoot = { 'a' => "hashref_value_1\n", 'b' => "hashref_value_2\n" };
$ABCD_LENGTH = $#abcd;

# no support currently for perl assign from list-like to array/hash.

#@abcd2 = ('fee','fi','fo','fum');
#%zoot2 = ( 'a' => 'b' );


## array access and length
$b = $abcd[1];
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

# broken hash as 'list' or fatcomma list
#%yy = ('lh_key', "list-hash-value\n");
#print $yy{'lh_key'};
#%yy = ('fch_key' , "fatcomma-hash-value\n");
#print $yy{'fch_key'};

