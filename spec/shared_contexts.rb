require 'hiera-puppet-helper'

shared_context "hieradata" do
  fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

  let :hiera_config do
    { :backends => ['rspec', 'yaml'],
      :hierarchy => [
        '%{fqdn}/%{calling_module}',
        '%{calling_module}',
        'common.yaml'
        ],
      :yaml => {
        :datadir => File.join(fixture_path, 'data') },
      :rspec => respond_to?(:hiera_data) ? hiera_data : {}
    }
  end

  let(:facts) { {
    :ipaddress => '10.42.0.5',
    :osfamily  => 'Debian',
    :operatingsystem => 'Debian',
    :lsbdistcodename => 'wheezy',
  } }

end