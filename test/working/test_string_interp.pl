$b = 'BAZ';

$s = "";
$s = '';
$s = '$b';
$s = "$b";
$s = " $b $b ";
$s = " \$ ";

# in curlys
$s = " ${b} ${b}";

# escaped dollar
$s = " \$b ";
$s = " \${b} ";
