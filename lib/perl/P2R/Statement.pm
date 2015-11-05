use PPI;

package PPI::Statement;

sub ruby_content {
    my ($self) = @_; 
    my $output = '';
    $output .= $self->ruby_start() // '';
    foreach my $kid ($self->children) {
	$output .= $kid->ruby_content;
    }
    $output .= $self->ruby_finish() // '';
    return $output;
}
sub ruby_start { 
    my ($self,$brack) = @_;
    if (defined $brack) {
	$self->{'ruby_start'} = $brack;
    }
    return $self->{'ruby_start'};
}

sub ruby_finish { 
    my ($self,$brack) = @_;
    if (defined $brack) {
	$self->{'ruby_finish'} = $brack;
    }
    return $self->{'ruby_finish'};
}

1;
