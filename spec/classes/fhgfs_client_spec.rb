require 'spec_helper'

describe 'fhgfs::client' do

  let(:facts) {{
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
    :lsbdistid => 'Debian',
  }}

  let(:user) { 'fhgfs' }
  let(:group) { 'fhgfs' }

  let(:params) {{
    :user  => user,
    :group => group,
  }}

  shared_examples 'debian_fhgfs-client' do |os, codename|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
      :lsbdistid => 'Debian',
    }}
    it { should contain_package('fhgfs-client') }
    it { should contain_package('kernel-package') }
    it { should contain_package('linux-headers-generic') }
    it { should contain_package('fhgfs-helperd') }
    it { should contain_package('fhgfs-client') }

    it { should contain_service('fhgfs-client').with(
        :ensure => 'running',
        :enable => true
    ) }

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

    it { should contain_file('/etc/fhgfs/fhgfs-client.conf').with({
      'ensure'  => 'present',
      'owner'   => user,
      'group'   => group,
      'mode'    => '0755',
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
      :lsbdistid => 'RedHat',
    }}
    let(:params){{
      :kernel_ensure => '12.036+nmu3'
    }}

    # kernel packages have different versions than fhgfs
    it { should contain_package('kernel-devel').with({
      'ensure' => '12.036+nmu3'
    }) }
  end

  context 'with given version' do
    let(:version) { '2012.10.r8.debian7' }
    let(:params) {{
      :package_ensure => version
    }}

    it { should contain_package('fhgfs-client').with({
      'ensure' => version
    }) }
    it { should contain_package('kernel-package').with({
      'ensure' => 'present'
    }) }
    it { should contain_package('fhgfs-helperd').with({
      'ensure' => version
    }) }
    it { should contain_package('fhgfs-client').with({
      'ensure' => version
    }) }
  end

  it { should contain_file('/etc/fhgfs/client.interfaces').with({
    'ensure'  => 'present',
    'owner'   => user,
    'group'   => group,
    'mode'    => '0755',
  }).with_content(/eth0/) }

  context 'interfaces file' do
    let(:params) {{
      :interfaces      => ['eth0', 'ib0'],
      :interfaces_file => '/etc/fhgfs/client.itf',
      :user            => user,
      :group           => group,
    }}

    it { should contain_file('/etc/fhgfs/client.itf').with({
      'ensure'  => 'present',
      'owner'   => user,
      'group'   => group,
      'mode'    => '0755',
    }).with_content(/ib0/) }


    it { should contain_file(
        '/etc/fhgfs/fhgfs-client.conf'
      ).with_content(/connInterfacesFile(\s+)=(\s+)\/etc\/fhgfs\/client.itf/)
    }
  end

  it { should contain_file(
    '/etc/fhgfs/fhgfs-client.conf'
  ).with_content(/logLevel(\s+)=(\s+)3/) }

  context 'changing log level' do
    let(:params) {{
      :log_level => 5,
    }}

    it { should contain_file(
      '/etc/fhgfs/fhgfs-client.conf'
    ).with_content(/logLevel(\s+)=(\s+)5/) }
  end

  context 'allow changing mgmtd_host' do
    let(:params) {{
      :mgmtd_host => '192.168.1.1',
    }}

    it {
      should contain_file(
        '/etc/fhgfs/fhgfs-client.conf'
      ).with_content(/sysMgmtdHost(\s+)=(\s+)192.168.1.1/)
    }
  end

end
