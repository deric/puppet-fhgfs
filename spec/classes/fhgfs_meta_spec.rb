require 'spec_helper'

describe 'fhgfs::meta' do
  shared_examples 'debian-mgmtd' do |os, codename|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
    }}
    it { should contain_package('fhgfs-meta') }
    it { should contain_package('fhgfs-utils') }

    it { should include_class('fhgfs::repo::debian') }

    it { should contain_service('fhgfs-meta').with(
        :ensure => 'running',
        :enable => true
    ) }

    it { should contain_file('/etc/fhgfs/fhgfs-meta.conf').with({
      'ensure'  => 'present',
      'owner'   => user,
      'group'   => group,
      'mode'    => '0755',
      'require' => 'Package[fhgfs-meta]',
    }) }


  end

  context 'on debian-like system' do
    let(:user) { 'fhgfs' }
    let(:group) { 'fhgfs' }

    it_behaves_like 'debian-mgmtd', 'Debian', 'squeeze'
    it_behaves_like 'debian-mgmtd', 'Debian', 'wheezy'
    it_behaves_like 'debian-mgmtd', 'Ubuntu', 'precise'
  end

end
