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

# string concat
$x = "12";
$x .= "3";

# string multiply
$x3 = $x x 3;
