use PPI;

package PPI::Node;

sub children_nws {
    my ($self) = @_;
    my @nws_kids = grep { !($_->isa("PPI::Token::Whitespace")); } $self->children;
    return( @nws_kids );
}
sub ruby_remove_trailing_semicolon {
    # How can we get rid of trailing semicolons? 
    # if our current node's last child is a semicolon, AND
    # if the next whitespace is a newline or we're at the end of the document, 
    # we should be able to safely remove the trailing semicolon.
    my ($self) = @_;
    my @kids = $self->children;
    for (my $i = 1; $i < $#kids; $i++) {
	my $nextkid = $kids[$i+1];
	my $curkid = $kids[$i];
	if ($curkid->isa("PPI::Statement")) {
	    my $has_trailing_semicolon;
	    my @substat = $curkid->children;
	    my $last_substat = $substat[-1];
	    if ($last_substat->isa("PPI::Token::Structure") && $last_substat eq ';') {
		$has_trailing_semicolon = 1;
	    }
	    if ( $has_trailing_semicolon && 
		 (! defined($nextkid) || 
		  ( $nextkid->isa("PPI::Token::Whitespace") && ($nextkid->content eq "\n") )
		 ) ) {
		$last_substat->set_ruby_remove(1);
	    }
	}
    }
    return 0;
}

sub token_replace {
    my ($self, $replace_ref) = @_;
    my @kids = $self->children;
    #print Data::Dumper->Dump($replace_ref);

    my $matched_all = 0;
    my $current_matcher = 0;
    my $in_a_match = 0;
    my $tok = 0; 

    my @commit_kids_for_deletion = ();
    my @kids_for_deletion = ();
    while ($tok < @kids) {

	if (defined $replace_ref->[$current_matcher]) {
	    my $match_type = $replace_ref->[$current_matcher]->[0];
	    my $match_needed = $replace_ref->[$current_matcher]->[1];
	    my $match_action = $replace_ref->[$current_matcher]->[2];
	    my $match_reqvalue = $replace_ref->[$current_matcher]->[3];
	    my $match_replaceval = $replace_ref->[$current_matcher]->[4];
	    my $match_class = "PPI::Token::${match_type}";
	    my $cur_class = ref($kids[$tok]);
	    my $is_class_match = $cur_class =~ $match_class;
	    if ( $is_class_match and $match_needed) {
		if (defined $match_reqvalue and $match_reqvalue ne $kids[$tok]->content) {
		    #print "DEBUG req'd match found, but incorrect req.value\n";
		    $in_a_match = 0;
		    $current_matcher = 0;
		    $tok++;
		} else {
		    #print "DEBUG req'd match found\n";
		    $in_a_match ++;
		    $current_matcher++;
		    if ($match_action eq 'toss') {
			push(@kids_for_deletion, $tok);
		    } elsif ($match_action eq 'replace') {
			Carp::croak("no replaceval given") unless (defined $match_replaceval);
			$kids[$tok]->set_content($match_replaceval);
		    }
		    $tok++;
		}
	    }
	    elsif ( $is_class_match and !$match_needed) {
		#print "DEBUG unreq'd match found\n";
		$in_a_match ++;
		$current_matcher++;
		push(@kids_for_deletion, $tok) if ($match_action eq 'toss');
		$tok++;
	    }
	    elsif ( !$is_class_match and !$match_needed) {
		#print "DEBUG unreq'd match not-found\n";
		$in_a_match ++;
		$current_matcher++;
	    } 
	    else {
		$in_a_match = 0;
		$current_matcher = 0;
		$tok++;
	    }
	    #print "DEBUG $match_class (",($current_matcher-1),") $cur_class (",($tok-1),") ; in-a-match:$in_a_match\n\n";
	    ## finality.
	    if ($in_a_match == scalar(@$replace_ref)) {
		#print "DEBUG Completed match found\n";
		$current_matcher = 0;
		#print "DEBUG need to remove the following entries: @kids_for_deletion\n";
		push @commit_kids_for_deletion , @kids_for_deletion;
	    }

	} else {
	    $tok++;
	}

	#
    }

    ## now remove tokens that we commited for deletion
    foreach my $tok (@commit_kids_for_deletion) {
	$self->remove_child( $kids[$tok]);
    }
}


sub to_ruby { # node
    my ($self) = @_;


    ## for variable statements, strip my/our/local and whitespace
    if ($self->isa("PPI::Statement::Variable")) {
	my @vartoks =  $self->children ;
	if ( $vartoks[0]->content() =~ /^(my|local|our)$/) {
	    $self->remove_child( $vartoks[0] );
	    # if whitespace immediately follows the removed token
	    # we should remove that also
	    if ( $vartoks[1]->isa("PPI::Token::Whitespace") ) {
		$self->remove_child( $vartoks[1] );
	    }
	}
    }
    if ($self->isa("PPI::Statement")) {
    ## remove whitespace between symbool, '='
	my @nws_kids = grep { !($_->isa("PPI::Token::Whitespace")); } $self->children;
	if ( $nws_kids[0]->isa("PPI::Token::Symbol") and
	     $nws_kids[1]->isa("PPI::Token::Operator") and
	     $nws_kids[1]->content eq '=' and
	     $nws_kids[2]->isa("PPI::Structure::List") ) {
	    if ($nws_kids[0] =~ /^\@/) {
		$nws_kids[2]->ruby_start('[');
		$nws_kids[2]->ruby_finish(']');
	    } elsif ($nws_kids[0] =~ /^\%/) {
		$nws_kids[2]->ruby_start('{');
		$nws_kids[2]->ruby_finish('}');
	    } 
	}
    }    

    ## Attempt to find initial 
    ##   "my ($a,$b,$c)=@_;" to use as function signature
    ##
    if ($self->isa("PPI::Statement::Sub")) {
	my ($funcsig,$defname);
	my @subkids = grep { !($_->isa("PPI::Token::Whitespace")); } $self->children;
	if ( $subkids[0]->isa("PPI::Token::Word") && 
	     ($subkids[0]->content eq 'sub') &&
	     $subkids[2]->isa("PPI::Structure::Block") ) {
	    $defname = $subkids[1]->content;
	    
	    my @blockkids = $subkids[2]->children_nws;
	    if ($blockkids[0]->isa("PPI::Statement::Variable")) {
		my @myvarkids = $blockkids[0]->children_nws;
		my @xx = map { ref($_);} @myvarkids;
		if ( ($myvarkids[0]->content eq 'my') &&
		     $myvarkids[1]->isa("PPI::Structure::List") && 
		     ($myvarkids[2]->content eq '=') &&
		     ($myvarkids[3]->content eq '@_')
		     
		    ) {
		    ## clone this PPI::Structure::List so we can reuse it as the function signature
		    $funcsig = $myvarkids[1]->clone;
		}
	    }
	    if (defined $funcsig) {
		$subkids[2]->remove_child($blockkids[0]);
		$subkids[1]->insert_after($funcsig); 
	    }
	}
    }

    ## BEGINNING OF LISTS, CONSTRUCTORS, ETC ##

    if ($self->isa("PPI::Structure::List")) {
	## some places above, we override the start/finish,
	## so preserve them
	$self->ruby_start( $self->ruby_start() // '(' );
	$self->ruby_finish( $self->ruby_finish() // ')');
    } elsif ($self->isa("PPI::Structure::Constructor")) {
	$self->ruby_start($self->start);
	$self->ruby_finish($self->finish);
    } elsif ($self->isa("PPI::Structure::Subscript")) {
	$self->ruby_start('[');
	$self->ruby_finish(']');
    } elsif ($self->isa("PPI::Structure::Condition")) {
	# insert space in case of "if(foo)" so it
	# turns into "if foo" and not "iffoo"
	$self->ruby_start(' ');
	$self->ruby_finish(' ');
    } elsif ($self->isa("PPI::Structure::For")) {
	# insert space in case of "for(###)" so it
	# turns into "for ###" and not "for###"
	$self->ruby_start(' ');
	$self->ruby_finish('');
    } elsif ($self->isa("PPI::Structure")) {
	#$self->ruby_start($self->start);
	#$self->ruby_finish($self->finish);
	$self->ruby_start('');
	$self->ruby_finish('');
###---------------------	
###   Statements
###---------------------	
    } elsif ($self->isa("PPI::Statement::Compound")) {
	# do not want to duplicate 'end' inside if/else/elsif chains
	# need either struct:block stat:compound, not both
	$self->ruby_start("");
	$self->ruby_finish("end #compound ");
    } elsif ($self->isa("PPI::Statement::Expression")) {
	$self->set_ruby_remove();
    } elsif ($self->isa("PPI::Statement::Sub")) {
	$self->ruby_start('');
	$self->ruby_finish("end #sub "); #closing out a subfunction
    } elsif ($self->isa("PPI::Statement")) {
	$self->ruby_start('');
	$self->ruby_finish('');
    } else {
	warn ref($self),"\n";
    }

    ## match+reg-sub or match+reg-transliterate should remove
    ## the match symbol '=~' and adjoining spaces so we can replace s/// with .sub()
    $self->token_replace(
	[ ["Symbol", 1, 'keep'],
	  ["Whitespace", 0, 'toss'],
	  ["Operator", 1, 'toss', '=~'],
	  ["Whitespace", 0, 'toss'],
	  ["Regexp::(Substitute|Transliterate)" ,1, 'keep'],
	]);

    ## replace 'use constant FOO => VALUE' with 'FOO = VALUE'
    $self->token_replace( 
	[ ["Word" , 1, 'toss', 'use'],
	  ["Whitespace" ,1, 'toss'],
	  ["Word" ,1, 'toss', 'constant'],
	  ["Whitespace" ,1, 'toss'],
	  ["Word" ,1, 'keep'],
	  ["Whitespace" ,0, 'keep'],
	  ["Operator" ,1, 'replace', '=>', '='],
	  ["Whitespace" ,0, 'keep'],
	]);

    # perl allows '$foo -> new()', replace with '$foo->new()' for 
    # later conversion to 'foo.new()'
    $self->token_replace( 
	[ ["Whitespace" ,0, 'toss'],
	  ["Operator" ,1, 'keep', '->'],
	  ["Whitespace" ,0, 'toss'],
	]);
	  
    ## Recursively descend into children
    foreach my $kid ($self->children) {
	$kid->to_ruby()
    }
}

1;
