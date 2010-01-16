require 'rubygems'
require 'rbconfig'

 Gem::Specification.new do |s|
   s.name      = 'archive-tar-external'
   s.version   = '1.2.3'
   s.summary   = 'A simple way to create tar archives using external calls'
   s.license   = 'Artistic 2.0'
   s.author    = 'Daniel Berger'
   s.email     = 'djberg96@gmail.com'
   s.homepage  = 'http://www.rubyforge.org/shards'
   s.test_file = 'test/test_archive_tar_external.rb'
   s.has_rdoc  = true
   s.files     = Dir['**/*'].reject{ |f| f.include?('CVS') }

   s.rubyforge_project = 'shards'

   s.extra_rdoc_files = [
      'README',
      'CHANGES',
      'MANIFEST',
      'doc/tar_external.txt'
   ]

   s.description = <<-EOF
      The archive-tar-external is a simple wrapper interface for creating
      tar files using your system's tar command. You can also easily compress
      your tar files with your system's compression programs such as zip, gzip,
      or bzip2.
   EOF

   s.add_development_dependency('test-unit', '>= 2.0.3')
   s.add_development_dependency('ptools', '>= 1.1.7')

   if Config::CONFIG['host_os'] =~ /mswin|dos|win32|cygwin|mingw|win32/i
      if RUBY_VERSION.to_f < 1.9 && RUBY_PLATFORM !~ /java/i
         s.add_dependency('win32-open3', '>= 0.3.1')
      end
   end
end
