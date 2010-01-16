require 'rubygems'
require 'rbconfig'

Gem::Specification.new do |spec|
  spec.name      = 'archive-tar-external'
  spec.version   = '1.3.0'
  spec.summary   = 'A simple way to create tar archives using external calls'
  spec.license   = 'Artistic 2.0'
  spec.author    = 'Daniel Berger'
  spec.email     = 'djberg96@gmail.com'
  spec.homepage  = 'http://www.rubyforge.org/shards'
  spec.test_file = 'test/test_archive_tar_external.rb'
  spec.has_rdoc  = true
  spec.files     = Dir['**/*'].reject{ |f| f.include?('git') }

  spec.rubyforge_project = 'shards'

  spec.extra_rdoc_files = [
    'README',
    'CHANGES',
    'MANIFEST',
    'doc/tar_external.txt'
  ]

  spec.description = <<-EOF
    The archive-tar-external is a simple wrapper interface for creating
    tar files using your system's tar command. You can also easily compress
    your tar files with your system's compression programs such as zip, gzip,
    or bzip2.
  EOF

  spec.add_development_dependency('test-unit', '>= 2.0.3')
  spec.add_development_dependency('ptools', '>= 1.1.7')

  if Config::CONFIG['host_os'] =~ /mswin|dos|win32|cygwin|mingw|win32/i
    if RUBY_VERSION.to_f < 1.9 && RUBY_PLATFORM !~ /java/i
      spec.add_dependency('win32-open3', '>= 0.3.1')
    end
  end
end
