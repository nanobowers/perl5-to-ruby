$stuff="abc";
$a=0;

#if multiline
if ($stuff==0) 
{
$b=1;
}
# if/elsif/else, nested
if($stuff eq 'abc') {
    $a=1;
} elsif('a' ne '2'){
    $b=0;
}else{
    if ($line == 'y') {
	$c=0;
    }
}

# unless multiline
unless($stuff eq 'def') 
{
  $cc=0; 
}

# unless/else
unless($a==1) {
    $d=1;
} else {
    $e=2;
}

# if/else, oneliner
#BREAKS# if($stuff eq 'abc') { $aa=1; } else { $bb=0;}

# unless oneliner
#BREAKS# unless($stuff eq 'def') { $cc=0; }

# ending if clause
$aaa = 1 if ($a eq '1');

# ending unless clause
$aaa = 1 unless ($a eq '1');
