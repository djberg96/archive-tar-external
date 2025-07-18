## 1.6.0 - 17-Jul-2025
* Now uses shellwords and stricter argument validation for tighter security.
  See IMPROVEMENTS.md in the doc directory for more details.

## 1.5.0 - 1-May-2021
* A fourth option was added to the constructor. This allows you to set the
  archive format. By default this is now set to 'pax'.

## 1.4.2 - 30-Apr-2021
* Switched from test-unit to rspec.
* Added tighter versioning for the development dependencies.
* Tests will now try to use gtar by default, if found.
* A fair number of rubocop suggestions were implemented, including
  the frozen string literal pragma.

## 1.4.1 - 19-Feb-2021
* Switched from rdoc to markdown.

## 1.4.0 - 23-Jan-2019
* Changed license to Apache-2.0.
* The VERSION constant is now frozen.
* Added some metadata to the gemspec.
* Cert updated, should be good for about 10 years.

## 1.3.3 - 16-Jan-2016
* This gem is now signed.
* Fixed some deprecation warnings in the test suite.
* Added an archive-tar-external.rb file for convenience.
* Updates to the Rakefile.

## 1.3.2 - 14-Mar-2014
* The create_archive method now accepts an optional second argument that
  specifies options to the tar command. The default is 'cf' (create file).
* The gem:create task was updated for Rubygems 2.x.
* Added rake as a development dependency.
* Ruby 1.8.x support has been dropped. This only matters for MS Windows.

## 1.3.1 - 20-Sep-2011
* Refactored the Rakefile a bit.

## 1.3.0 - 16-Jan-2010
* Altered the source code layout, which requires a change in your require
  line. It's now require 'archive/tar/external'.
* Moved some content from the .txt file to the README.
* Updated one test to use a skip as needed.
* Moved source code to github.

## 1.2.3 - 25-Sep-2009
* Fixed a packaging bug.
* Added cygwin and mingw to Windows checks.
* Now requires open3 properly for Ruby 1.9 on Windows.
* Minor modifications to the gemspec.
* Added the 'gem' rake task.

## 1.2.2 - 28-Jul-2009
* Compatibility fixes for Ruby 1.9.x and JRuby.
* Singleton methods that were previously synonyms are now true aliases.
* License changed to Artistic 2.0.
* Several gemspec updates, including an updated description, the addition
  of a license and development dependencies and refactored platform handling.
* Added test-unit and ptools as development dependencies for the test suite.
* Some refactoring of the test suite to take advantage of some of the features
  in test-unit 2.x.
* Renamed the test file to test_archive_tar_external.rb.

## 1.2.1 - 30-Jul-2007
* The TarError class is now Tar::Error.
* Added a Rakefile with tasks for installation and testing.
* Removed the install.rb file. Installation is now handled by the Rakefile.
* Documentation updates.

## 1.2.0 - 7-Apr-2006
* Project renamed 'archive-tar-external'.
* The 'Tar' class is now Tar::External.
* The RAA project name is now tar-external.
* Added the Tar::External.uncompress_archive class method for archives
  that already exist.
* Added the Tar::External.extract_archive class method for tarballs
  that already exist.
* Added the Tar::External#compressed_archive_name= method.

## 1.1.1 - 1-Mar-2006
* Replaced PLATFORM with RUBY_PLATFORM since the former is deprecated
  for Ruby 1.9/2.0.

## 1.1.0 - 10-Feb-2006
* Internal refactoring changes - now uses block form of Open3.popen3.
* Most methods now return self instead of true (better for chaining).
* Corresponding test suite changes.

## 1.0.0 - 1-Sep-2005
* Moved project to RubyForge.
* Modified the constructor to accept a file pattern.  If present, becomes
  a shortcut for Tar.new + Tar#create_archive.
* Constructor merely calls .to_s on the archive name, rather than validating
  that it's a String argument.
* You can now specify the tar program you wish to use, e.g. "tar", "gtar", etc.
* Fixed a bug in Tar#uncompress_archive where it wasn't finding the appropriate
  compressed archive name.
* Added aliases for most methods whereby you can omit the word "archive" in
  the method name now, e.g. Tar#compress is an alias for Tar#compress_archive.
* Now more polite about closing open handles from Open3.
* The (rdoc) documentation is now inlined.
* Removed the tarsimple.rd and tarsimple.html files.
* Made most documentation rdoc friendly.
* Updated the README and MANIFEST files.
* Removed the INSTALL file.  The installation instructions are now included
  in the README file.
* Test suite updates.
* Added a gemspec.

## 0.3.0 - 10-Aug-2004
* Added the update_archive() method.
* The expand_archive() method has been renamed to extract_archive().
  For backward's compatability, an alias remains so you may use
  either method name.
* The extract_archive() method now accepts a list of file names as
  an argument.  If present, then only those file names are extracted.
  If not, then the entire archive is extracted.
* Added corresponding tests and documentation updates.

## 0.2.0 - 9-Aug-2004
* Added the add_to_archive() method.
* Removed the VERSION() class method. Use the constant instead.
* Changed "TarException" and "CompressionException" to "TarError" and
  "CompressError", respectively.
* Moved rd documentation into its own file under the 'doc' directory.
* Added unit tests and updated the docs.
* Removed the html file.  You can generate that on your own if you
  wish using the rd2 tool.
* Added warranty information.

## 0.1.0 - 24-Jan-2003
* Initial Release
