require 'hiera'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppetlabs_spec_helper/puppetlabs_spec_helper'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.hiera_config = File.expand_path(File.join(__FILE__, '../fixtures/hiera.yaml'))
end
