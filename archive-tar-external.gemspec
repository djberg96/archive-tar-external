require 'rubygems'
require 'rbconfig'

Gem::Specification.new do |spec|
  spec.name       = 'archive-tar-external'
  spec.version    = '1.6.0'
  spec.summary    = 'A simple way to create tar archives using external calls'
  spec.license    = 'Apache-2.0'
  spec.author     = 'Daniel Berger'
  spec.email      = 'djberg96@gmail.com'
  spec.homepage   = 'http://github.com/djberg96/archive-tar-external'
  spec.test_files = Dir['spec/*.rb']
  spec.files      = Dir['**/*'].reject{ |f| f.include?('git') }
  spec.cert_chain = Dir['certs/*']

  spec.metadata = {
    'homepage_uri'          => 'https://github.com/djberg96/archive-tar-external',
    'bug_tracker_uri'       => 'https://github.com/djberg96/archive-tar-external/issues',
    'changelog_uri'         => 'https://github.com/djberg96/archive-tar-external/blob/main/CHANGES.md',
    'documentation_uri'     => 'https://github.com/djberg96/archive-tar-external/wiki',
    'source_code_uri'       => 'https://github.com/djberg96/archive-tar-external',
    'wiki_uri'              => 'https://github.com/djberg96/archive-tar-external/wiki',
    'rubygems_mfa_required' => 'true',
    'funding_uri'           => 'https://github.com/sponsors/djberg96',
    'github_repo'           => 'https://github.com/djberg96/archive-tar-external'
  }

  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec', '~> 3.9')
  spec.add_development_dependency('ptools', '~> 1.5')
  spec.add_development_dependency('rubocop')
  spec.add_development_dependency('rubocop-rspec')

  spec.description = <<-EOF
    The archive-tar-external is a simple wrapper interface for creating
    tar files using your system's tar command. You can also easily compress
    your tar files with your system's compression programs such as zip, gzip,
    or bzip2.
  EOF
end
