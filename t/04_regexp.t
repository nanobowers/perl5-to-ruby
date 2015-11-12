# -*- perl -*-
use P2R;
use Test::Simple tests => 17;
use Test::P2R;

ok_p2r('$a=~ s|\0||g;',      q|a.gsub!(/\0/,'');|,   'gsub');
ok_p2r('$a=~s|\s+$||;',      q|a.sub!(/\s+$/,'');|,  'sub dollar-tail');
ok_p2r('$a=~s|\s+| |g;',     q|a.gsub!(/\s+/,' ');|, 'gsub with space');
ok_p2r('$b=($a !~ m/\'/);',  q|b=(a !~ /'/);|,       'nomatch oper' );
ok_p2r('$b=($a =~ m/abc/);', q|b=(a =~ /abc/);|,     'match oper' );
ok_p2r('$b=($a =~ /abc/);',  q|b=(a =~ /abc/);|,     'match oper, no-m' );
ok_p2r('$b=($a =~ m|abc|);',  'b=(a =~ %r|abc|);',   'match oper, pipes to %r regex' ,1 );
ok_p2r('$a=~s|\'$||xe;',     q|a.sub!(/'$/xe,'');|,  'xe args'); 
ok_p2r('$a=~s|^\'||;',       q|a.sub!(/^'/,'');|,    'empty sub!');
ok_p2r('$a=~s/a/b/;',        q|a.sub!(/a/,'b');|,    'simple sub!');
ok_p2r('$a=~tr/123/456/;',   q|a.tr!('123','456');|, 'tr numbers');
ok_p2r('$a=~tr|a|b|;',       q|a.tr!('a','b');|,     'tr letters');
ok_p2r('$a=~y/a/b/;',        q|a.tr!('a','b');|,     'y-tr letters');
ok_p2r('$zz =~ s|\0||g;',    q|zz.gsub!(/\0/,'');|,  'sub: space-space');
ok_p2r('$zz =~s/\0//g;',     q|zz.gsub!(/\0/,'');|,  'sub: space-nospace');
ok_p2r('$zz=~ s|\0||g;',     q|zz.gsub!(/\0/,'');|,  'sub: nospace-space');
ok_p2r('$zz=~s|\0||g;',      q|zz.gsub!(/\0/,'');|,  'sub: nospace-nospace');

