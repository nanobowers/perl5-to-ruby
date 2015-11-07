use PPI;

package PPI::Token;

sub ruby_fix_var { ## non-oo method ##
    my ($sigil,$varname) = @_;
    ## special-case vars such as $_ , $|, $1, $2, 
    ## and others that typically dont start with an alpha, underscore, or :: 
    ## don't want to be renamed
    if ($varname eq '_' or $varname=~/^[0-9]$/ or $varname !~ /^([A-Za-z_]|::)/) {
	return("${sigil}${varname}");
    }
    ## lowercasing of vars
    my @varlist = split(/::/,$varname);
    $varlist[-1] =~ s/^([A-Z][A-Za-z_0-9]*)/lc($1)/gxe;
    $varname = join('::',@varlist);
    return $varname
}

sub to_ruby {
    my ($self,$indent) = @_; 
    #DEBUG print ref($self)."'".$self->content."'"."\n";
    #DEBUG print "#".ref($self)."#";
    if ( $self->isa("PPI::Token::Cast")) {
	# unsupported recast of array to hash, etc.
	# not sure how to handle this case
	# silently ignore for now, let's hope ruby ducktyping
	# will save us
	my $cast = $self->content;
	$self->set_ruby($cast);

    } elsif ( $self->isa("PPI::Token::Comment")) {
	# comments are mostly as-is, but we can replace the editor-mode-string
	my $comment = $self->content;
	$comment =~ s/-\*-\s*perl\s*-\*-/-*- ruby -*-/g;
	$self->set_ruby($comment);
    } elsif ( $self->isa("PPI::Token::DashedWord")) {
	# unsupported
	croak("no support for DashedWord. should be using Word");
    } elsif ( $self->isa("PPI::Token::Number")) {
	my $num = $self->content;
	## ruby doesnt allow leading decimal
	$num = "0${num}" if ($num =~ /^\./);
	$self->set_ruby($num);
#    } elsif ( $self->isa("PPI::Token::Number::Binary")) {
#    } elsif ( $self->isa("PPI::Token::Number::Exp")) {
#    } elsif ( $self->isa("PPI::Token::Number::Float")) {
#    } elsif ( $self->isa("PPI::Token::Number::Hex")) {
#    } elsif ( $self->isa("PPI::Token::Number::Octal")) {
#    } elsif ( $self->isa("PPI::Token::Number::Version")) {
    } elsif ( $self->isa("PPI::Token::Prototype")) {
	## do not handle prototypes
	## will just set them as empty for now
	$self->set_ruby("");
    } elsif ( $self->isa("PPI::Token::Quote::Double")) {
	## attempt to interpolate vars in double-quoted strs
	my $doublequote =  $self->content;
	$doublequote =~ s/([\$\@\%])\{(\w+)}\}/"#{".ruby_fix_var($1,$2)."}"/gxe;
	$doublequote =~ s/([\$\@\%])(\w+)/"#{".ruby_fix_var($1,$2)."}"/gxe;
	$self->set_ruby($doublequote);
    } elsif ( $self->isa("PPI::Token::Quote::Interpolate")) {
	my $word =  $self->content;
	$word =~ s/^qq/%Q/;
	$self->set_ruby($word);
    } elsif ( $self->isa("PPI::Token::Quote::Literal")) {
	my $word =  $self->content;
	$word =~ s/^q/%q/;
	$self->set_ruby($word);
    } elsif ( $self->isa("PPI::Token::QuoteLike::Regexp")) {
	my $word =  $self->content;
	$word =~ s/^qr/%r/;
	$self->set_ruby($word);
    } elsif ( $self->isa("PPI::Token::QuoteLike::Words")) {
	my $word =  $self->content;
	$word =~ s/^qw/%w/;
	$self->set_ruby($word);
    } elsif ( $self->isa("PPI::Token::QuoteLike::Command")) {
	my $word =  $self->content;
	$word =~ s/^qx/%x/;
	$self->set_ruby($word);
    } elsif ( $self->isa("PPI::Token::Data") ||
	      $self->isa("PPI::Token::End") ||
	      $self->isa("PPI::Token::HereDoc") ||
	      $self->isa("PPI::Token::Label") ||
	      # pass magic-vars through for now. 
	      # may need do some mapping in the future
	      $self->isa("PPI::Token::Magic") ||
	      $self->isa("PPI::Token::Quote::Single") ||
	      $self->isa("PPI::Token::Quote") ||
	      $self->isa("PPI::Token::QuoteLike::Backtick") ||
	      $self->isa("PPI::Token::QuoteLike::Readline") ||
	      $self->isa("PPI::Token::Regexp::Match") ||
	      $self->isa("PPI::Token::Regexp") ||
	      $self->isa("PPI::Token::Separator") ||
	      $self->isa("PPI::Token::Structure") ||
	      $self->isa("PPI::Token::Whitespace")) {
	my $cmd =  $self->content;
	$self->set_ruby_as_perl();
    } elsif ( $self->isa("PPI::Token::Attribute") || # unsupported
              $self->isa("PPI::Token::BOM") ||  # unsupported byte order mark?
              $self->isa("PPI::Token::QuoteLike") ||
              $self->isa("PPI::Token::Unknown")) {
        croak("unknown/unsupported token type: '".ref($self)."'");

    } else {
	$self->set_ruby_as_perl()
    }
}

##===========================================================

package PPI::Token::ArrayIndex;
sub to_ruby {
    my ($self) = @_;
    my $arrayindex = $self->content;
    # $#var to var.length
    $arrayindex =~ s/^\$\#//; 
    $self->set_ruby("${arrayindex}.length");
}

##===========================================================

package PPI::Token::Operator;

## change to ruby method call syntax (arrows to dots)
## change perl eq/ne/gt/lt string compare methods to ruby standard compares
our $oper_map = { 
    'eq' => '==',
    'ne' => '!=',
    'gt' => '>',
    'lt' => '<',
    'ge' => '>=',
    'le' => '<=',
    'cmp' => '<=>',
    '->' => '.',
    "." => '+', # string concatenation
    '.=' => '+=', 
    'x' => '*', # string multiply
    'x=' => '*=', 
    '//' => '||', # logical-defined-or (leaning-or)
    '//=' => '||=', 

};

sub to_ruby {
    my ($self) = @_;
    my $oper = $self->content;
    my $rubyoper = $oper_map->{$oper} // $oper;
    $self->set_ruby($rubyoper);
}

##===========================================================

package PPI::Token::Pod;

sub to_ruby {
    my ($self) = @_;
    my @podlines = split("\n", $self->content);
    my @rdoclines = ();
    for my $podline (@podlines) {
	## currently, nested bold/code/ital modifers are unsupported.
	$podline =~s/C\<([^>]*)\>/<tt>$1<\/tt>/g;
	$podline =~s/I\<([^>]*)\>/<em>$1<\/em>/g;
	$podline =~s/B\<([^>]*)\>/<b>$1<\/b>/g;
	
	if ($podline=~/^\s*\=(pod|cut|back|over.*)/x) { 
	    # skip =pod, =cut, etc
	    next;
	} elsif ($podline=~/^\s*\=item\s+\*/x) {
	    $podline=~s/\s*\=item\s+\*/\*/;
	} elsif ($podline=~/^\s*\=item\s+([0-9]+)/x) {
	    $podline=~s/\s*\=item\s+(\d+)/$1\./;
	} elsif ($podline=~/^\s*\=head1/x) {
	    $podline=~s/\s*\=head1/=/;
	} elsif ($podline=~/^\s*\=head2/x) {
	    $podline=~s/\s*\=head2/\=\=/;
	}
	push @rdoclines, "# $podline\n";
    }
    $self->set_ruby(join('',@rdoclines));
}

##===========================================================

package PPI::Token::Regexp::Substitute;

sub to_ruby {
    my ($self) = @_;
    my $subst_expr = $self->content;
    # convert to .sub! method. though maybe not what you really want in ruby
    $subst_expr=~s/^s//;
    my $delimiter = substr($subst_expr,0,1);
    $delimiter = '\|' if ($delimiter eq '|');
    my @w = split($delimiter,$subst_expr);
    #replace string returned from split may be undef/empty
    $w[2] = "" unless defined $w[2];  

    ## default to sub!, no opts
    ## if flags exist, then pick those up, perhaps switching to gsub
    my ($subop, $reopts) = ('sub!', $w[3] // "");
    if ($reopts =~ 'g') {
	$subop = 'gsub!';
	$reopts=~s/g//; # remove the 'g'
    }

    my $regex = ".${subop}(/$w[1]/${reopts}, '$w[2]')";
    $self->set_ruby($regex);
}

##===========================================================

package PPI::Token::Regexp::Transliterate;

sub to_ruby {
    my ($self) = @_;
    my $transexpr = $self->content;
    # convert to .tr! method. though maybe not what you really want in ruby
    $transexpr=~s/^tr//;
    my $delimiter = substr($transexpr,0,1);
    $delimiter = '\|' if ($delimiter eq '|');
    my @w = split($delimiter,$transexpr);
    #replace string returned from split may be undef/empty
    $w[2] = "" unless defined $w[2];  
    my $regex = ".tr!('$w[1]','$w[2]')";
    $self->set_ruby($regex);
} 

##===========================================================

package PPI::Token::Symbol;
sub to_ruby {
    my ($self) = @_;
    my $word =  $self->content;
    $word =~ s/^([\$\@\%\&])//;
    my $sigil = $1;
    $word = PPI::Token::ruby_fix_var($sigil,$word);
    if ($sigil eq '&') { 
	$self->set_ruby_type("Function_Call"); 
    } elsif ($sigil eq '$') {
	$self->set_ruby_type("Scalar"); 
    } elsif ($sigil eq '@') {
	$self->set_ruby_type("Array"); 
    } elsif ($sigil eq '%') {
	$self->set_ruby_type("Hash"); 
    }
    $self->set_ruby($word);
} 

##===========================================================

package PPI::Token::Word;
our $ruby_word_map = {
    'sub' => 'def',
    'undef' => 'nil',
    'STDOUT' => '$stdout',
    'STDERR' => '$stderr',
    'say' => 'puts',
};
sub to_ruby {
    my ($self) = @_;
    my $word =  $self->content;
    my $rubyword = $ruby_word_map->{$word} // $word;
    $self->set_ruby($rubyword);
}

1;

##PPI::Token::ArrayIndex 	Token getting the last index for an array   	  	
##PPI::Token::Attribute 	A token for a subroutine attribute   	  	
##PPI::Token::BOM 	Tokens representing Unicode byte order marks   	  	
##PPI::Token::Cast 	A prefix which forces a value into a different context   	  	
##PPI::Token::Comment 	A comment in Perl source code   	  	
##PPI::Token::DashedWord 	A dashed bareword token   	  	
##PPI::Token::Data 	The actual data in the __DATA__ section of a file   	  	
##PPI::Token::End 	Completely useless content after the __END__ tag   	  	
##PPI::Token::HereDoc 	Token class for the here-doc   	  	
##PPI::Token::Label 	Token class for a statement label   	  	
##PPI::Token::Magic 	Tokens representing magic variables   	  	
##PPI::Token::Number 	Token class for a number   	  	
##PPI::Token::Number::Binary 	Token class for a binary number   	  	
##PPI::Token::Number::Exp 	Token class for an exponential notation number   	  	
##PPI::Token::Number::Float 	Token class for a floating-point number   	  	
##PPI::Token::Number::Hex 	Token class for a binary number   	  	
##PPI::Token::Number::Octal 	Token class for a binary number   	  	
##PPI::Token::Number::Version 	Token class for a byte-packed number   	  	
##PPI::Token::Operator 	Token class for operators   	  	
##PPI::Token::Pod 	Sections of POD in Perl documents   	  	
##PPI::Token::Prototype 	A subroutine prototype descriptor   	  	
##PPI::Token::Quote 	String quote abstract base class   	  	
##PPI::Token::Quote::Double 	A standard "double quote" token   	  	
##PPI::Token::Quote::Interpolate 	The interpolation quote-like operator   	  	
##PPI::Token::Quote::Literal 	The literal quote-like operator   	  	
##PPI::Token::Quote::Single 	A 'single quote' token   	  	
##PPI::Token::QuoteLike 	Quote-like operator abstract base class   	  	
##PPI::Token::QuoteLike::Backtick 	A `backticks` command token   	  	
##PPI::Token::QuoteLike::Command 	The command quote-like operator   	  	
##PPI::Token::QuoteLike::Readline 	The readline quote-like operator   	  	
##PPI::Token::QuoteLike::Regexp 	Regexp constructor quote-like operator   	  	
##PPI::Token::QuoteLike::Words 	Word list constructor quote-like operator   	  	
##PPI::Token::Regexp 	Regular expression abstract base class   	  	
##PPI::Token::Regexp::Match 	A standard pattern match regex   	  	
##PPI::Token::Regexp::Substitute 	A match and replace regular expression token   	  	
##PPI::Token::Regexp::Transliterate 	A transliteration regular expression token   	  	
##PPI::Token::Separator 	The __DATA__ and __END__ tags   	  	
##PPI::Token::Structure 	Token class for characters that define code structure   	  	
##PPI::Token::Symbol 	A token class for variables and other symbols   	  	
##PPI::Token::Unknown 	Token of unknown or as-yet undetermined type   	  	
##PPI::Token::Whitespace 	Tokens representing ordinary white space   	  	
##PPI::Token::Word 	The generic "word" Token  
