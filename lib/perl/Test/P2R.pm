# -*- perl -*-
use Test::Simple;

sub ok_p2r { 
    my ($perlcode,$expect_rb,$comment,$debug) = @_;
    my $doc = PPI::Document->new( \$perlcode );
    $doc->to_ruby;
    my $rubycode = $doc->ruby_content;
    if (defined $debug) {
	print "PERL: $perlcode\n";
	print "RUBY: $rubycode\n";
	print "EXRB: $expect_rb\n";
    }
    (my $expectrb_no_spaces = $expect_rb) =~s/\s+//g;
    (my $ruby_no_spaces = $rubycode) =~s/\s+//g;
    ok( $ruby_no_spaces eq $expectrb_no_spaces ,$comment)
}

1;
