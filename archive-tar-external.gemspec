require 'rubygems'
require 'rbconfig'

Gem::Specification.new do |spec|
  spec.name       = 'archive-tar-external'
  spec.version    = '1.4.0'
  spec.summary    = 'A simple way to create tar archives using external calls'
  spec.license    = 'Apache-2.0'
  spec.author     = 'Daniel Berger'
  spec.email      = 'djberg96@gmail.com'
  spec.homepage   = 'http://github.com/djberg96/archive-tar-external'
  spec.test_file  = 'test/test_archive_tar_external.rb'
  spec.files      = Dir['**/*'].reject{ |f| f.include?('git') }
  spec.cert_chain = Dir['certs/*']

  spec.extra_rdoc_files = [
    'README',
    'CHANGES',
    'MANIFEST',
    'doc/tar_external.txt'
  ]

  spec.metadata = {
    'homepage_uri'      => 'https://github.com/djberg96/archive-tar-external',
    'bug_tracker_uri'   => 'https://github.com/djberg96/archive-tar-external/issues',
    'changelog_uri'     => 'https://github.com/djberg96/archive-tar-external/blob/master/CHANGES',
    'documentation_uri' => 'https://github.com/djberg96/archive-tar-external/wiki',
    'source_code_uri'   => 'https://github.com/djberg96/archive-tar-external',
    'wiki_uri'          => 'https://github.com/djberg96/archive-tar-external/wiki'
  }

  spec.add_development_dependency('test-unit')
  spec.add_development_dependency('ptools')
  spec.add_development_dependency('rake')

  spec.description = <<-EOF
    The archive-tar-external is a simple wrapper interface for creating
    tar files using your system's tar command. You can also easily compress
    your tar files with your system's compression programs such as zip, gzip,
    or bzip2.
  EOF
end
