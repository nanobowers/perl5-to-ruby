
## application configuration module

package P2R::App;
use Getopt::Long;
use File::Basename;
use feature qw(say);

our $opthash = {};
our $class = 'P2R::App';
use constant FALSE => 0;
use constant TRUE => 1;

use constant OPTNAME => 0;
use constant DEFAULT => 1;
use constant COMMENT => 2;
our @optlist = (["no-func-replace", 
		 FALSE, 
		 "don't replace perl functions with ruby equivalents"
		],
    );
    
sub make_read_accessor {
    my($klass, $field) = @_;
    my $accessor = sub {
	return $opthash->{$field};
    };
    my $fullname = "${klass}::$field";
    ## add to the symbol-table
    *{$fullname} = $accessor;

}

sub config {
    my (@args)=@_;

    {
	local @ARGV = @args;

	## prevent single-dash long options
	foreach $item (@args) {
	    die "Long option '${item}' should be written with two dashes.\n" if
		($item =~ /^\-[\w][a-zA-Z0-9_-]/);
	}

	Getopt::Long::Configure(qw(no_ignore_case posix_default));
	my %opts;

	foreach my $item (@optlist) {
	    my $optname = $item->[OPTNAME];
	    my $funcname = $optname; $funcname =~ tr/-/_/;
	    $item->[FUNCNAME] = $funcname;
	    my $default = $item->[DEFAULT];
	    $opts{$optname} = \$opthash->{$funcname}; ## add for getopt
	    $opthash->{$funcname} = $default; ## set default value
	    make_read_accessor($class, $funcname);
	}
	$opts{'h|help'} = sub { &help(); };
	GetOptions(%opts) or Carp::croak('Option parsing failed');

    }

}

sub help {
    my $progname = basename($0);

    say "usage : $progname FILE [options]";
    say "";
    say "options :";
    foreach my $item (@optlist) {
	$name =  $item->[OPTNAME];
	$comment = $item->[COMMENT];
	say "   --$name : $comment"
    }
    say "";
    exit 0;
}
1;
