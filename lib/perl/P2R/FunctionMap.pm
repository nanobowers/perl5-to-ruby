

## perl to ruby map

local $FUNCMAP = { 

# Functions for SCALARs or strings
# chomp, chop, chr, crypt, fc, hex, index, lc, lcfirst, length, oct, ord, 
# pack, q//, qq//, reverse, rindex, sprintf, substr, tr///, uc, ucfirst, y///
    'chomp VALUE|$_' => 'VALUE.chomp!',
    'chop VALUE|$_' => 'VALUE.chop!',
    'crypt VALUE, REST' => 'VALUE.crypt REST',
    'chr VALUE|$_' => "VALUE.chr",
    'lc VALUE|$_' => 'VALUE.downcase',
    'lcfirst VALUE|$_' => 'VALUE.capitalize.swapcase',
    'length VALUE|$_' => 'VALUE.length',
    'ord VALUE|$_' => "VALUE.ord",
    'rindex VALUE, REST' => "VALUE.rindex REST",
    'uc VALUE|$_' => 'VALUE.upcase',
    'ucfirst VALUE|$_' => 'VALUE.capitalize',
    

# Regular expressions and pattern matching
# m//, pos, qr//, quotemeta, s///, split, study
    'split PATTERN, EXPR|$_, REST' => 'EXPR.split PATTERN, REST',
# Numeric functions
# abs, atan2, cos, exp, hex, int, log, oct, rand, sin, sqrt, srand
    "abs VALUE" => "VALUE.abs",
    "atan2" => "Math.atan2",
    "cos" => "Math.cos",
    "exp" => "Math.exp",
    "log" => "Math.log",
    "sin" => "Math.sin",
    "sqrt" => "Math.sqrt",
    'int VALUE' => "VALUE.to_i",
    'hex VALUE' => "VALUE.hex",
    'oct VALUE' => "VALUE.oct",
    'rand' => "Random.rand",
    'srand' => "Random.srand",

# Functions for real @ARRAYs
# each, keys, pop, push, shift, splice, unshift, values

# Functions for list data
# grep, join, map, qw//, reverse, sort, unpack

    'reverse VALUE' => "VALUE.reverse",

# Functions for real %HASHes
# delete, each, exists, keys, values

# Input and output functions
# binmode, close, closedir, dbmclose, dbmopen, die, eof, fileno, flock, format, 
# getc, print, printf, read, readdir, readline rewinddir, say, seek, seekdir, 
# select, syscall, sysread, sysseek, syswrite, tell, telldir, truncate, warn, write

# Functions for fixed-length data or records
# pack, read, syscall, sysread, sysseek, syswrite, unpack, vec

# Functions for filehandles, files, or directories
# -X, chdir, chmod, chown, chroot, fcntl, glob, ioctl, link, lstat, mkdir, 
# open, opendir, readlink, rename, rmdir, stat, symlink, sysopen, umask, unlink, utime
    'chdir' => 'Dir.chdir',
    'chmod' => 'File.chmod',
    'chown' => 'File.chown',
    'link' => 'File.link', 
    'lstat' => 'File.lstat',
    'mkdir' => 'Dir.mkdir',
    'open' => 'File.open',
    'opendir' => 'Dir.open',
    'readlink' => 'File.readlink', 
    'rename' => 'File.rename', 
    'rmdir' => 'Dir.rmdir',
    'stat' => 'File.stat',
    'symlink' => 'File.symlink',
    'sysopen' => 'IO.sysopen',
    'umask' => 'File.umask',
    'unlink' => 'File.unlink',
    'utime' => 'File.utime',

# Fetching user and group info
# endgrent, endhostent, endnetent, endpwent, getgrent, getgrgid, getgrnam, getlogin,
# getpwent, getpwnam, getpwuid, setgrent, setpwent
    'endgrent' => 'Etc.endgrent',
    'endpwent' => 'Etc.endpwent',
    'getgrent' => 'Etc.getgrent',
    'getgrgid' => 'Etc.getgrgid',
    'getgrnam' => 'Etc.getgrnam',
    'getlogin' => 'Etc.getlogin',
    'getpwent' => 'Etc.getpwent',
    'getpwnam' => 'Etc.getpwnam',
    'getpwuid' => 'Etc.getpwuid',
    'setgrent' => 'Etc.setgrent',
    'setpwent' => 'Etc.setpwent',
#NORUBY 'endhostent' => ??
#NORUBY 'endnetent' => ??

# Fetching network info
# endprotoent, endservent, gethostbyaddr, gethostbyname, gethostent, getnetbyaddr, 
# getnetbyname, getnetent, getprotobyname, getprotobynumber, getprotoent, getservbyname,
# getservbyport, getservent, sethostent, setnetent, setprotoent, setservent
#NORUBY for any..

# Time-related functions
# gmtime, localtime, time, times
    'time' => 'Time.now',
    'gmtime VALUE' => 'VALUE.gmtime',
    'localtime VALUE' => 'VALUE.localtime',
#NORUBY 'times' => ??

};

1;
