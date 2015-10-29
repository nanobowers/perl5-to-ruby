## comment
my $stuff = 'abc\0';  # end of line comment
$stuff=~ s|\0||g;

my $dataString = "  'ab c' "  ;
$dataString=~s|\s+$||;
$dataString=~s|\s+| |g; # gsub
#$dataString=~s|\s+| |g if ($dataString !~ m|'|); ## don't compress spaces in strings...
$dataString=~s|'$||xe; #'for strings
$dataString=~s|^'||; #'for strings


$a='aaa';
$a=~s/a/b/;
$a=~tr/123/456/;
$a=~tr|a|b|;

$stuff =~ s|\0||g;
$stuff =~s|\0||g;
$stuff=~ s|\0||g;
$stuff=~s|\0||g;
