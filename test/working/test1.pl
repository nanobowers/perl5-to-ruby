
my $stuff = 'abc\0';
$stuff=~ s|\0||g; #baz
# hi
print "$stuff\n";

print();

if($stuff eq 'abc') {
    print "matched abc\n";
} elsif('a' ne '2'){
}else{
    if ($line == 'y') {
	print qq{bar};
    }
}

@abcd = qw(fee fi fo fum);
%zoot={};
$ABCD_LENGTH = $#abcd;
print "${ABCD_LENGTH}\n";

$a='aaa';
$a=~s/a/b/;
$a=~tr/123/456/;
$a=~tr|a|b|;
#Foo->b();
$b=$a[1];

#for my $Foo (1..5) { print "$Foo\n"; }
# for(var $i = 0; $i < $max; $i++) { }
#my($v) = 'vv';

@myarray = [ 1, 2, 3 ];
%myhash = { 'b' => 'c' };


$dataString=~s|\s+$||;
$dataString=~s|\s+| |g; # gsub
#$dataString=~s|\s+| |g if ($dataString !~ m|'|); ## don't compress spaces in strings...
$dataString=~s|'$||xe; #'for strings
$dataString=~s|^'||; #'for strings


#use constant SRFNAME      => 58;   ## STRING  
#use constant LIBSECUR=>59;   ## INTEGER
#################################################################################################

# $_ = '';

print $+ ;
print $abc;
$stuff =~ s|\0||g;
$stuff =~s|\0||g;
$stuff=~ s|\0||g;
$stuff=~s|\0||g;
