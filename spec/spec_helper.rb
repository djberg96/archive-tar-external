require 'rspec'
require 'ptools'

RSpec.configure do |config|
  config.filter_run_excluding(:gzip) unless File.which('gzip')
end
