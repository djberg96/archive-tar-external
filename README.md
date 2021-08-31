[![Ruby](https://github.com/djberg96/archive-tar-external/actions/workflows/ruby.yml/badge.svg)](https://github.com/djberg96/archive-tar-external/actions/workflows/ruby.yml)

## Description
A simple tar & compress library that nicely wraps external system calls.

## Installation
`gem install archive-tar-external`
   
## Synopsis
```ruby
require 'archive/tar/external' # or 'archive-tar-external'
   
# Create an archive of all files with an ".rb" extension, the long way.
t = Archive::Tar::External.new('test.tar')
t.create_archive('*.rb')
t.compress_archive('gzip')
   
# Same, but the short way.
t = Archive::Tar::External.new('test.tar', '*.rb', 'gzip')
```

## Prerequisites
* The 'tar' command line program.
* At least one compression program, e.g. gzip, bzip2, zip, etc.
   
## Known Issues

### OSX
It appears that the BSD tar that ships on Mac does not implement the -u
option properly by default, and will add a file to the archive even if
the timestamp of the file hasn't changed.

The OSX issue was effectively addressed in version 1.5.0, where the default
archive format was added and set to 'pax'.

If you come across any other issues, please report them on the project
page at https://github.com/djberg96/archive-tar-external.

### Windows
MS Windows did not have a tar commmand until part way through the Windows 10
lifecycle. If you do not have it then you will need to install it, either as
a native command or use something like Cygwin.

### Solaris
The tar program that comes with Solaris will not raise an error if you
try to expand a file from an archive that does not contain that file.

Note that Solaris is essentially dead at this point, so I will generally
not be accepting patches for it.

## History
This project was originally named "archive-tarsimple", but was renamed
on April 7, 2006. Versions of this gem prior to that date are no longer
available.

## License
Apache-2.0

## Warranty
This package is provided "as is" and without any express or
implied warranties, including, without limitation, the implied
warranties of merchantability and fitness for a particular purpose.

## Copyright
(C) 2003 - 2021 Daniel J. Berger
All Rights Reserved

## Author
Daniel J. Berger
