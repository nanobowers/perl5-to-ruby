use PPI;

package PPI::Document;

sub to_ruby {
    my ($self) = @_;

    #TODO# trailing semicolon removal at document level.
    #TODO# this doesn't catch everything, should be possible at 
    #TODO# other levels also, so need to move it later.

    $self->ruby_remove_trailing_semicolon();

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

1;
