require 'spec_helper'

describe 'fhgfs::install' do
  shared_examples 'debian-install' do |os, codename|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
    }}

    user = 'fhgfs'
    group = 'fhgfs'

    it { should include_class('fhgfs::repo') }

    it { should contain_file('/etc/fhgfs/fhgfs-client.conf').with({
      'ensure'  => 'present',
      'owner'   => user,
      'group'   => group,
      'mode'    => '0755',
      'require' => 'Package[fhgfs-utils]',
    }) }

  end

  context 'on debian-like system' do
    it_behaves_like 'debian-install', 'Debian', 'squeeze'
    it_behaves_like 'debian-install', 'Debian', 'wheezy'
    it_behaves_like 'debian-install', 'Ubuntu', 'precise'
  end

end
