# -*- perl -*-
use P2R;
use Test::Simple tests => 7;
use Test::P2R;

ok_p2r('$a="$b";',    q|a="#{b}";|,          'scalar in string 1');
ok_p2r('$a="${b}";',  q|a="#{b}";|,          'scalar in string 2');
ok_p2r('$a="$1 $2";', q|a="#{$1} #{$2}";|,   'magic-vars in string');
ok_p2r('$a="@x";',    q|a="#{x}";|,   'array in string 1');
ok_p2r('$a="@{x}";',  q|a="#{x}";|,   'array in string 2');

# for a brief while we accidentally interpreted hashes in strings which perl doesnt do, afaik.
# this was corrupting printfs with %s, %d, etc..

ok_p2r('$a=sprintf("%0.3d",$foo);',      q|a=sprintf("%0.3d",foo);|,   'printf decimal in string');
ok_p2r('$a=sprintf("%s",$foo);',      q|a=sprintf("%s",foo);|,   'printf decimal in string');


