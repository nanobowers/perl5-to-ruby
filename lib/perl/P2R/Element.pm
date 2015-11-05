use PPI;

package PPI::Element;

################################
# accessors for ruby-tags
################################
sub set_ruby_remove {
    my ($self, $ruby_remove) = @_;
    $self->{'ruby_remove'} = $ruby_remove // 1;
}
sub get_ruby_remove {
    ## setting a ruby type of the content here, may use later?
    my ($self) = @_;
    return $self->{'ruby_remove'} // 0;
}
sub set_ruby {
    ## setting a ruby version of the content here, may use later?
    my ($self, $ruby_content) = @_;
    $self->{'ruby'} = $ruby_content;
    return $self->{'ruby'};
}
sub set_ruby_as_perl {
    ## setting a ruby version of the content same as existing perl content
    my ($self) = @_;
    $self->{'ruby'} = $self->content();
    return $self->{'ruby'};
}

sub ruby_content {
    my ($self) = @_;
    if (defined $self->{'ruby'}) {
	return "" if ($self->get_ruby_remove);
	return $self->{'ruby'};
    }
    return ref($self);
}
sub set_ruby_type {
    ## setting a ruby type of the content here, may use later?
    my ($self, $ruby_type) = @_;
    $self->{'ruby_type'} = $ruby_type;
}
1;
