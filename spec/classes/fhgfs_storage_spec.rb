require 'spec_helper'

describe 'fhgfs::storage' do
  let(:hiera_data) { { 'fhgfs::mgmtd_host' => "foo.bar" } }

  let(:facts) {{
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
    :lsbdistid => 'Debian',
  }}

  let(:user) { 'fhgfs' }
  let(:group) { 'fhgfs' }

  let(:params) {{
    'user'  => user,
    'group' => group,
  }}

  shared_examples 'debian-storage' do |os, codename|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
      :lsbdistid => 'Debian',
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
      :interfaces      => ['eth0', 'ib0'],
      :interfaces_file => '/etc/fhgfs/store.itf',
      :user            => user,
      :group           => group,
    }}

    it { should contain_file('/etc/fhgfs/store.itf').with({
      'ensure'  => 'present',
      'owner'   => user,
      'group'   => group,
      'mode'    => '0755',
    }).with_content(/ib0/) }


    it { should contain_file(
        '/etc/fhgfs/fhgfs-storage.conf'
      ).with_content(/connInterfacesFile(\s+)=(\s+)\/etc\/fhgfs\/store.itf/)
    }
  end

  it { should contain_file(
    '/etc/fhgfs/fhgfs-storage.conf'
  ).with_content(/logLevel(\s+)=(\s+)3/) }

  context 'changing log level' do
    let(:params) {{
      :log_level => 5,
    }}

    it { should contain_file(
      '/etc/fhgfs/fhgfs-storage.conf'
    ).with_content(/logLevel(\s+)=(\s+)5/) }
  end

  context 'set mgmtd host' do
    let(:params) {{
      :mgmtd_host => 'mgmtd.fhgfs.com',
    }}

    it { should contain_file(
      '/etc/fhgfs/fhgfs-storage.conf'
    ).with_content(/sysMgmtdHost(\s+)=(\s+)mgmtd.fhgfs.com/) }
  end

  context 'set mgmtd tcp port' do
    let(:params) {{
      :mgmtd_tcp_port => 9009,
    }}

    it { should contain_file(
      '/etc/fhgfs/fhgfs-storage.conf'
    ).with_content(/connMgmtdPortTCP(\s+)=(\s+)9009/) }
  end

end
