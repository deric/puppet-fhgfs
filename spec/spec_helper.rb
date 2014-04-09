require 'puppet'
require 'rspec'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-hiera-puppet'
require 'rspec/expectations'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
end

Puppet::Util::Log.level = :warning
Puppet::Util::Log.newdestination(:console)
