require 'spec_helper'

describe 'fhgfs::client' do
  shared_examples 'debian_fhgfs-client' do |os, codename|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
    }}
    it { should contain_package('fhgfs-client') }
    it { should contain_package('kernel-package') }
    it { should contain_package('fhgfs-helperd') }
    it { should contain_package('fhgfs-client') }


    it { should contain_service('fhgfs-helperd').with(
        :ensure => 'running',
        :enable => true
    ) }

    it { should contain_file('/etc/fhgfs/fhgfs-mounts.conf').with({
      'ensure'  => 'present',
      'owner'   => user,
      'group'   => group,
      'mode'    => '0755'
    }) }

  end

  context 'on debian-like system' do
    let(:user) { 'fhgfs' }
    let(:group) { 'fhgfs' }

    it_behaves_like 'debian_fhgfs-client', 'Debian', 'squeeze'
    it_behaves_like 'debian_fhgfs-client', 'Debian', 'wheezy'
    it_behaves_like 'debian_fhgfs-client', 'Ubuntu', 'precise'
  end

  context 'on RedHat' do
    let(:facts) {{
      :operatingsystem => 'RedHat',
      :osfamily => 'RedHat',
      :lsbdistcodename => '6',
    }}

    it { should contain_package('kernel-devel') }
  end

  context 'with given version' do
    let(:facts) {{
      :operatingsystem => 'Debian',
      :osfamily => 'Debian',
      :lsbdistcodename => 'wheezy',
    }}
    let(:version) { '2012.10.r8.debian7' }
    let(:params) {{
      :package_ensure => version
    }}

    it { should contain_package('fhgfs-client').with({
      'ensure' => version
    }) }
    it { should contain_package('kernel-package').with({
      'ensure' => version
    }) }
    it { should contain_package('fhgfs-helperd').with({
      'ensure' => version
    }) }
    it { should contain_package('fhgfs-client').with({
      'ensure' => version
    }) }
  end

end
