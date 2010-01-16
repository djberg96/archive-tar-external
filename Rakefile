require 'rake'
require 'rake/testtask'

desc "Install the archive-tar-external library (non-gem)"
task :install do
   dest = File.join(Config::CONFIG['sitelibdir'], 'archive')
   Dir.mkdir(dest) unless File.exists? dest
   cp 'lib/archive/tar_external.rb', dest, :verbose => true
end

desc 'Build the archive-tar-external gem'
task :gem do
   spec = eval(IO.read('archive-tar-external.gemspec'))
   Gem::Builder.new(spec).build
end

desc 'Install the archive-tar-external library as a gem'
task :install_gem => [:gem] do
   file = Dir["*.gem"].first
   sh "gem install #{file}"
end

Rake::TestTask.new do |t|
   t.warning = true
   t.verbose = true
end
