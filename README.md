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
The tar program that comes with Solaris will not raise an error if you
try to expand a file from an archive that does not contain that file.

If you come across any other issues, please report them on the project
page at https://github.com/djberg96/archive-tar-external.

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
