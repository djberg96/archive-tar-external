require 'rspec'
require 'ptools'

RSpec.configure do |config|
  config.filter_run_excluding(:gzip) unless File.which('gzip')
  config.filter_run_excluding(:gtar) unless File.which('gtar')
end
