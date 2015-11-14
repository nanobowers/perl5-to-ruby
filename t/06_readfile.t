# -*- perl -*-
use P2R;
use Test::Simple tests => 1;
use Test::P2R;

ok_p2r('$a = <$IFILE>', "a = ifile.gets", "readline operator to gets")
