#-*- perl -*-
use P2R;
 
use Test::Simple tests => 15;

sub ok_p2r { 
    my ($perlcode,$expect_rb,$comment) = @_;
    my $doc = PPI::Document->new( \$perlcode );
    $doc->to_ruby;
    my $rubycode = $doc->ruby_content;
    print "PERL: {{$perlcode}}\n";
    print "RUBY: {{$rubycode}}\n";
    (my $expectrb_no_spaces = $expect_rb) =~s/\s+//g;
    (my $ruby_no_spaces = $rubycode) =~s/\s+//g;
    ok( $ruby_no_spaces eq $expectrb_no_spaces ,$comment)
}

ok_p2r( "sub foo {\n  my (\$abc,\$deef) = \@_;\n}",
	"def foo (abc,deef)\n\nend",
	'sub definition');
ok_p2r('foo("a","b");', 'foo("a","b");', 'sub call with args');
ok_p2r('&foo("z","e");', 'foo("z","e");', 'sub call-amper');
ok_p2r('foo();', 'foo();', 'sub call, noargs');
ok_p2r('baz','baz', 'bareword sub call');
ok_p2r('Biz->buz();','Biz.buz();', 'oo style sub call');
ok_p2r('Biz -> buz();','Biz.buz();', 'oo style sub call arrow-sep1');
ok_p2r('Biz ->buz();','Biz.buz();', 'oo style sub call arrow-sep2');
ok_p2r('Biz-> buz();','Biz.buz();', 'oo style sub call arrow-sep3');

## builtins
ok_p2r('say "foo";', 'puts "foo";', 'no-paren builtin call');
ok_p2r('say("foo");', 'puts("foo");', 'with-paren builtin call');

ok_p2r('print Foo->new;', 'print Foo.new;', 'two arg print oo call');

ok_p2r('print $a[1], "\n";', 'print a[1], "\n";', 'two arg print');
ok_p2r('print 1, 2;', 'print 1, 2;', 'two arg print, nums');
ok_p2r('print A1, A2;', 'print A1, A2;', 'two arg print, constants');
