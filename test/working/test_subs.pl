sub foo {
    my ($abc,$deef) = @_;
    print "$abc\n";
    print "$deef\n";
}

foo();
&foo();

#broken for ruby compile, as it wants args on the function
# foo('a','b');
# &foo('z','e');
    
#if ( 1 ==2) { $b = 1; }
