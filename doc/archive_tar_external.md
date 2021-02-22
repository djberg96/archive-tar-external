## Description
A simple tar interface using external system calls.

## Synopsis
```ruby
# Assuming we have three .txt files, t1.txt, t2.txt, t3.txt ...
require 'archive/tar/external'
include Archive

t = Tar::External.new(archive_name: "myfile.tar")
 
t.create_archive("*.txt")
t.compress_archive("bzip2") # 'myfile.tar.bz2' now exists

t.uncompress_archive("bunzip2")

t.archive_name # "myfile.tar"
t.archive_info # ["t1.txt", "t2.txt", "t3.txt"]

t.add_to_archive("t4.txt", "t5.txt")
t.expand_archive
```

## Constants
`VERSION`- The current version number of this library. This is a string.

## Singleton Methods
`.new(archive_name, pattern=nil, program=nil)`

Creates an instance of an Archive::Tar::External object. The `archive_name` is
the name of the tarball. While a '.tar' extension is recommended based on
years of convention, it is not enforced.
   
If `pattern` is provided, then the `create_archive` method is called internally.
   
If `program` is provided, then the `compress_archive` method is called internally.

Note that `archive_name` name must be a string, or a `TypeError` is raised.

`.expand_archive(archive_name, file1 [, file2, ...])`

Identical to the instance method of the same name, except that you must
specify the `archive_name`, and the tar program is hard coded to `tar xf`.

`.uncompress_archive(archive_name, program='gunzip')`

Identical to the instance method of the same name, except that you must
specify the +archive_name+ as the first argument.

## Instance Methods
```
#add(file1 [, file2, ...])
#add_to_archive(file1 [, file2, ...])
```

Adds a list of files to the current archive. At least one file must be
provided or an `Archive::Tar::Error` is raised.

```
#archive_info
#info
```

Returns an array of file names that are included within the tarball.

`#archive_name`

Returns the current archive name.

`#archive_name=`

Sets the current archive name.

```
#compress(program="gzip")
#compress_archive(program="gzip")
```

Compresses the tarball using the program you pass to this method. The default is "gzip".

Note that any arguments you want to be passed along with the program can simply
be included as part of the program, e.g. "gzip -f".

```
#create(file_pattern)
#create_archive(file_pattern, options = 'cf')
```

Creates a new tarball, including those files which match `file_pattern`
using `options`, which are set to 'cf' (create file) by default.

```
#expand_archive(files=nil)
#extract_archive(files=nil)
```

Expands the contents of the tarball. Note that this method does NOT delete the tarball.

If file names are provided, then only those files are extracted.

`#tar_program`

Returns the name of the tar program used. The default is "tar".

`#tar_program=(program_name)`

Sets the name of the tar program to be used.

```
#uncompress(program="gunzip")
#uncompress_archive(program="gunzip")
```

Uncompresses the tarball using the program you pass to this method. The default is "gunzip".

Like the `compress_archive` method, you can pass arguments along as part of the method call.

```
#update(files)
#update_archive(files)
```

Updates the given `files` in the archive, i.e they are added if they
are not already in the archive or have been modified.

## Exceptions
`Archive::Tar::Error`

Raised if something goes wrong during the execution of any methods that
use the tar command internally.

`Archive::Tar::CompressError`

Raised if something goes wrong during the `compress_archive` or `uncompress_archive` methods.
