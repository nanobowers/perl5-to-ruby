
# Implicit Func to InstMethod, zero or one args
## perl[func] -> ruby[ $_.func]
## perl[func VALUE] -> ruby[ VALUE.func]
sub ImpFuncToInstMeth {
    my ($rubyfunc) = @_;
    my %arghash = @arglist;
    $arghash{'min'} //= 0;
    $arghash{'max'} //= 1;
    $arghash{'default'} //= '$_';
    my @allowed = qw(min max default);
    foreach my $key (keys(%arghash)) {
	die "bad key $key" unless (grep {/$key/} @allowed);
    }
    print "VALUE.$rubyfunc $arghash{min} $arghash{max}\n";
}

# Implicit Func to ClassMethod, zero or one args
## perl[func] -> ruby[ func $_]
## perl[func VALUE] -> ruby[ func VALUE]
# ImpFuncToClassMeth01
sub ImpFuncToClassMeth { 
    my ($rubyfunc,@arglist) = @_;
    my %arghash = @arglist;
    $arghash{'min'} //= 0;
    $arghash{'max'} //= 1;
    $arghash{'default'} //= '$_';
    my @allowed = qw(min max default);
    foreach my $key (keys(%arghash)) {
	unless (grep {/$key/} @allowed) {
	    warn "CM $key\n";
	}
    }
    print "$rubyfunc $arghash{min} $arghash{max}\n";
    
}
## direct-map args
sub ArgMap { 
    my ($rubyfunc,@arglist) = @_;
    my %arghash = @arglist;
    $arghash{'min'} //= $arghash{'args'} // 0;
    $arghash{'max'} //= $arghash{'args'};
    my @allowed = qw(min max args);
    foreach my $key (keys(%arghash)) {
	unless (grep {/$key/} @allowed) {
	    warn "ARG $key\n";
	}
    }
    print "$rubyfunc $arghash{min} $arghash{max}\n";
}
sub ListOrScalarFunc { 
    my ($rubyfunc,@arglist) = @_;#
}

## perl to ruby map

local $FUNCMAP = { 

    # Functions for SCALARs or strings
    # chomp, chop, chr, crypt, fc, hex, index, lc, lcfirst, length, oct, ord, 
    # pack, q//, qq//, reverse, rindex, sprintf, substr, tr///, uc, ucfirst, y///
    'chomp' => ImpFuncToInstMeth('chomp!'),
    'chop' => ImpFuncToInstMeth('chop!'),
    'crypt VALUE, REST' => 'VALUE.crypt REST',
    'chr' => ImpFuncToInstMeth("chr"),
    'lc' => ImpFuncToInstMeth('downcase'),
    'lcfirst' => ImpFuncToInstMeth('capitalize.swapcase'),
    'length' => ImpFuncToInstMeth('length'),
    'ord' => ImpFuncToInstMeth("ord"),
    'rindex VALUE, REST' => ImpFuncToInstMeth("rindex", "min" => 2),
    #sprintf is the same

    ##  we need special handling for substr
    #    'substr' => { "2 arg: substr(value,idx)" => "VALUE[idx..-1]",
    #		  "3 arg: substr(value,idx,len)" => "VALUE[idx,len]",
    #		  "4 arg: substr(value,idx,len,replaceval)" => undef, #unsupported!
    #    },

    'uc' => ImpFuncToInstMeth('upcase'),
    'ucfirst' => ImpFuncToInstMeth('capitalize'),
    

    # Regular expressions and pattern matching
    # m//, pos, qr//, quotemeta, s///, split, study
    'split PATTERN, EXPR|$_, REST' => 'EXPR.split PATTERN, REST',
    # Numeric functions
    # abs, atan2, cos, exp, hex, int, log, oct, rand, sin, sqrt, srand
    'abs' => ImpFuncToInstMeth("abs"),
    "atan2" => ArgMap( "Math.atan2", 'args' => 2),
    "cos" => ImpFuncToClassMeth("Math.cos"),
    "exp" => ImpFuncToClassMeth("Math.exp"),
    "log" => ImpFuncToClassMeth("Math.log"),
    "sin" => ImpFuncToClassMeth("Math.sin"),
    "sqrt" => ImpFuncToClassMeth("Math.sqrt"),
    'int' => ImpFuncToInstMeth("to_i"),
    'hex' => ImpFuncToInstMeth("hex"),
    'oct' => ImpFuncToInstMeth("oct"),
    'rand' => ImpFuncToClassMeth( "Random.rand", "default"=>'1'),
    'srand' => ArgMap( "Random.srand", 'min'=> 0, 'max'=>1),

    # Functions for real @ARRAYs
    # each, keys, pop, push, shift, splice, unshift, values

    # Functions for list data
    # grep, join, map, qw//, reverse, sort, unpack

#currently unsupported   'reverse' => ListOrScalarFunc("ARGS", "reverse", $_),

    # Functions for real %HASHes
    # delete, each, exists, keys, values
    #   PERL delete $hash{$key} ==> RUBY hash.delete key
    #   PERL each  - no good analogy here, might be able to be done with ruby 
    #     enumerators, but doubtful that it's the 'right' thing.
    #   PERL exists $hash{$key} ==> RUBY hash.has_key? key (is this close enough??)
    'keys' => ImpFuncToInstMeth("keys", 'min'=>1),
    'values' => ImpFuncToInstMeth("values", 'min'=>1),

    # Input and output functions
    # binmode, close, closedir, dbmclose, dbmopen, die, eof, fileno, flock, format, 
    # getc, print, printf, read, readdir, readline rewinddir, say, seek, seekdir, 
    # select, syscall, sysread, sysseek, syswrite, tell, telldir, truncate, warn, write
    'binmode' => ImpFuncToInstMeth("binmode", 'min'=>1, 'max'=>2),
    'close' => ImpFuncToInstMeth("close", 'min'=>1),
    'closedir' => ImpFuncToInstMeth("close", 'min'=>1),
    'die' => ArgMap("abort"),
    'print' => ArgMap('print'),
    'printf' => ArgMap('printf'),
    'say' => ArgMap('puts'),
    'warn' => ArgMap("warn"),

    'sysseek' => ImpFuncToInstMeth("sysseek", 'min'=>3, 'max'=>3),
    #   'sysread' # bad params?

    # Functions for fixed-length data or records
    # pack, read, syscall, sysread, sysseek, syswrite, unpack, vec

    # Functions for filehandles, files, or directories
    # -X, chdir, chmod, chown, chroot, fcntl, glob, ioctl, link, lstat, mkdir, 
    # open, opendir, readlink, rename, rmdir, stat, symlink, sysopen, umask, unlink, utime
    'chdir' => ImpFuncToClassMeth('Dir.chdir', 'default' => 'ENV[\'HOME\']||ENV[\'LOGDIR\']'),
    'chmod' => ArgMap('File.chmod'),
    'chown' => ArgMap('File.chown'),
    'link' => ArgMap('File.link'), 
    'lstat' => ImpFuncToClassMeth('File.lstat'),
    'mkdir' => ImpFuncToClassMeth('Dir.mkdir', 'default' => '$_', 'default2' => "0777", 'max'=>2),
    'open' => ArgMap('File.open'),
    'opendir' => ArgMap('Dir.open', 'args'=>2),
    'readlink' => ImpFuncToClassMeth('File.readlink'),
    'rename' => ArgMap('File.rename', 'args' =>2), 
    'rmdir' => ImpFuncToClassMeth('Dir.rmdir'),
    'stat' => ImpFuncToClassMeth('File.stat'),
    'symlink' => ArgMap('File.symlink', 'args' =>2), 
    'sysopen' => ArgMap('IO.sysopen', 'min'=>3, 'max'=>4),
    'umask' =>  ArgMap('File.umask', 'min'=>0, 'max'=>1),
    'unlink' => ImpFuncToClassMeth('File.unlink', 'default'=>'$_', 'max'=> 1e3),
    'utime' => ImpFuncToClassMeth('File.utime','max'=> 1e3),

    # Fetching user and group info
    # endgrent, endhostent, endnetent, endpwent, getgrent, getgrgid, 
    # getgrnam, getlogin, getpwent, getpwnam, getpwuid, setgrent, setpwent
    'endgrent' => ArgMap('Etc.endgrent','args'=>0),
    'endpwent' => ArgMap('Etc.endpwent','args'=>0),
    'getgrent' => ArgMap('Etc.getgrent','args'=>0),
    'getgrgid' => ArgMap('Etc.getgrgid','args'=>1),
    'getgrnam' => ArgMap('Etc.getgrnam','args'=>2),
    'getlogin' => ArgMap('Etc.getlogin','args'=>0),
    'getpwent' => ArgMap('Etc.getpwent','args'=>0),
    'getpwnam' => ArgMap('Etc.getpwnam','args'=>1),
    'getpwuid' => ArgMap('Etc.getpwuid','args'=>1),
    'setgrent' => ArgMap('Etc.setgrent','args'=>0),
    'setpwent' => ArgMap('Etc.setpwent','args'=>0),
    #NORUBY 'endhostent' => ??
    #NORUBY 'endnetent' => ??

    # Fetching network info
    # endprotoent, endservent, gethostbyaddr, gethostbyname, gethostent, getnetbyaddr, 
    # getnetbyname, getnetent, getprotobyname, getprotobynumber, getprotoent, getservbyname,
    # getservbyport, getservent, sethostent, setnetent, setprotoent, setservent
    #NORUBY for any..

    # Time-related functions
    # gmtime, localtime, time, times
    'time' => ArgMap('Time.now'),
    'gmtime' => ImpFuncToInstMeth('gmtime'),
    'localtime' => ImpFuncToInstMeth('localtime'),
    #NORUBY 'times' => ??

};

1;
