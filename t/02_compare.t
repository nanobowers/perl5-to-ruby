# -*- perl -*-
use P2R;
use Test::Simple tests => 14;
use Test::P2R;

ok_p2r('$aval0 = ($a == 1)', 'aval0 = (a == 1)', 'compare ==');
ok_p2r('$aval1 = ($a != 1)', 'aval1 = (a != 1)', 'compare !=');
ok_p2r('$aval2 = ($a > 1)',  'aval2 = (a > 1)',  'compare >');
ok_p2r('$aval3 = ($a < 1)',  'aval3 = (a < 1)',  'compare <');
ok_p2r('$aval4 = ($a >= 1)', 'aval4 = (a >= 1)', 'compare >=');
ok_p2r('$aval5 = ($a <= 1)', 'aval5 = (a <= 1)', 'compare <=');
ok_p2r('$aval6 = ($a <=> 1)', 'aval6 = (a <=> 1)', 'compare <=>');

ok_p2r('$bval0 = ($b eq 1)', 'bval0 = (b == 1)', 'compare eq');
ok_p2r('$bval1 = ($b ne 1)', 'bval1 = (b != 1)', 'compare ne');
ok_p2r('$bval2 = ($b gt 1)', 'bval2 = (b > 1)',  'compare gt');
ok_p2r('$bval3 = ($b lt 1)', 'bval3 = (b < 1)',  'compare lt');
ok_p2r('$bval4 = ($b ge 1)', 'bval4 = (b >= 1)', 'compare ge');
ok_p2r('$bval5 = ($b le 1)', 'bval5 = (b <= 1)', 'compare le');
ok_p2r('$bval6 = ($b cmp 1)', 'bval6 = (b <=> 1) ', 'compare cmp');
