require 'spec_helper'

describe 'fhgfs::storage' do

  let(:facts) {{
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
  }}

  let(:user) { 'fhgfs' }
  let(:group) { 'fhgfs' }

  shared_examples 'debian-storage' do |os, codename|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
    }}

    it { should contain_package('fhgfs-utils') }
    it { should contain_service('fhgfs-storage').with(
        :ensure => 'running',
        :enable => true
    ) }

    it { should contain_file('/etc/fhgfs/fhgfs-storage.conf').with({
      'ensure'  => 'present',
      'owner'   => user,
      'group'   => group,
      'mode'    => '0755',
    }) }

    it { should contain_file('/storage').with({
      'ensure'  => 'directory',
      'owner'   => user,
      'group'   => group,
    }) }
  end

  context 'on debian-like system' do
    let(:user) { 'fhgfs' }
    let(:group) { 'fhgfs' }

    let('fhgfs::storage_directory') { '/storage' }

    #it_behaves_like 'debian-storage', 'Debian', 'squeeze'
    it_behaves_like 'debian-storage', 'Debian', 'wheezy'
    it_behaves_like 'debian-storage', 'Ubuntu', 'precise'
  end

  context 'with given version' do
    let(:version) { '2012.10.r8.debian7' }
    let(:params) {{
      :package_ensure => version
    }}

    it { should contain_package('fhgfs-storage').with({
      'ensure' => version
    }) }
  end


  it { should contain_file('/etc/fhgfs/storage.interfaces').with({
    'ensure'  => 'present',
    'owner'   => user,
    'group'   => group,
    'mode'    => '0755',
  }).with_content(/eth0/) }

  context 'interfaces file' do
    let(:params) {{
      :interfaces => ['eth0', 'ib0']
    }}

    it { should contain_file('/etc/fhgfs/storage.interfaces').with({
      'ensure'  => 'present',
      'owner'   => user,
      'group'   => group,
      'mode'    => '0755',
    }).with_content(/ib0/) }
  end

end
