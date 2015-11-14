
open FH, "X";
open OFH, ">", "X2";

while (<FH>) {
    print OFH "foobar\n";
}
close FH;
close OFH;

open $XXI, "<X2" or die "diexxi";
open $XXO, ">X3" or die "diexxo";

$a="baz";
while (<$XXI>) {
    print $XXO $a;
    print "biz", "baz", "buz\n";
}

close $XXI;

close $XXO;

