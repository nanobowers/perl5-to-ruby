
# scalar assignment seems to work

use constant FOO1 => 11 ;
use constant FOO2 =>12 ;
use constant FOO3=> 13 ;
use constant FOO4=>14 ;

my $foo = "0";
$a = 1;
@abcd = qw(fee fi fo fum);
$zoot = { 'a' => 'b'};
$ABCD_LENGTH = $#abcd;

# no support currently for perl assign from list-like to array/hash.

#@abcd2 = ('fee','fi','fo','fum');
#%zoot2 = ( 'a' => 'b' );

$b = $abcd[1];
$ABCD_LENGTH = $#abcd;

$a_1 = 1;
$a_A = 1; 
$aBc = 1;
$A = 1;
$Abc = 1;
$_ = 0;
$_ = $+;


