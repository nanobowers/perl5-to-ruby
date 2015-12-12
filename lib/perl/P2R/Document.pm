use PPI;

package PPI::Document;

sub to_ruby {
    my ($self) = @_;

    ## iterate through the document
    foreach my $kid ($self->children) {
	$kid->to_ruby();
    }
}
sub ruby_content {
    my ($self) = @_;
    my $output = '';
    foreach my $kid ($self->children) {
	$output .= $kid->ruby_content;
    }
    return $output;
}

sub remove_trailing_semicolons {
    my ($self)=@_;
    ## remove whitespace before endofline, e.g.: '   \n' to cleanup line end.
    ## then remove the semicolon preceding the '\n'
    $self->remove_end_of_line_whitespace;
    $self->remove_end_of_line_semicolons;
    return 0;
}

sub remove_end_of_line_whitespace {
    my ($self) = @_;
    my $wspaces = $self->find("PPI::Token::Whitespace");
    foreach my $ws (@$wspaces) {
	if ($ws->content() =~ /\n\z/) {
	    my $prevtoken = $ws->previous_token();
	    if ( $prevtoken and 
		 $prevtoken->isa("PPI::Token::Whitespace") and 
		 $prevtoken =~ /^\S+$/ ) {
		$prevtoken->remove();
	    }
	}
    }
    return 0;
}

sub remove_end_of_line_semicolons {
    my ($self) = @_;

    my $semicolons = $self->find( 
	sub {
	    my ($topnode,$curelem) = @_;
	    return( $curelem->isa("PPI::Token::Structure") and $curelem eq ';' );
	} );

    foreach my $curelem (@$semicolons) {
	my $nextelem = $curelem->next_token();
	if (!$nextelem) {
	    ## remove if there is no next element (likely EOF case)
	    $curelem->remove();
	} elsif ( $nextelem->isa("PPI::Token::Whitespace") and $nextelem->content =~ /\n\z/) {
	    $curelem->remove();
	}
    }
    return 0;
}

sub fix_fatcomma_bareword_keys {
    my ($self)=@_;
    # perl Statement::Expressions may be something like:
    # %a=( FOO=>"bar");
    # $a={ FOO=>"bar"};
    # when the fat-comma (=>) is used, perl replaces FOO with 'FOO'.
    # we will make this literal translation

    my $expressions = $self->find("PPI::Statement::Expression");
    foreach my $expr (@$expressions) {
	my @children_nws = $expr->children_nws;
	for ($i = 0; $i < $#children_nws; $i++) {
	    my $curchild = $children_nws[$i];
	    my $nextchild = $children_nws[$i+1];
	    if ($curchild->isa("PPI::Token::Word") and
		$nextchild->isa("PPI::Token::Operator") and 
		$nextchild->content eq '=>') {
		my $word_value = $curchild->content;
		my $quote_token = PPI::Token::Quote::Single->new("'${word_value}'");
		$curchild->insert_after($quote_token);
		$curchild->remove();
	    }
	}
    }
}
1;
