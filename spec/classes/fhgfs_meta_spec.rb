require 'spec_helper'
require 'shared_contexts'

describe 'fhgfs::meta' do
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

  shared_examples 'debian-meta' do |os, codename|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
      :lsbdistid => 'Debian',
    }}
    it { should contain_package('fhgfs-meta') }
    it { should contain_package('fhgfs-utils') }

    it { should contain_class('fhgfs::repo::debian') }

    it { should contain_service('fhgfs-meta').with(
        :ensure => 'running',
        :enable => true
    ) }

    it { should contain_file('/etc/fhgfs/fhgfs-meta.conf').with({
      'ensure'  => 'present',
      'owner'   => user,
      'group'   => group,
      'mode'    => '0755',
    }) }
  end

  context 'on debian-like system' do
    let(:user) { 'fhgfs' }
    let(:group) { 'fhgfs' }

    it_behaves_like 'debian-meta', 'Debian', 'wheezy'
    it_behaves_like 'debian-meta', 'Ubuntu', 'precise'
  end

  context 'allow changing parameters' do
    let(:params){{
        :mgmtd_host => '192.168.1.1'
    }}

    it {
      should contain_file(
        '/etc/fhgfs/fhgfs-meta.conf'
      ).with_content(/sysMgmtdHost(\s+)=(\s+)192.168.1.1/)
    }
  end

  context 'with given version' do
    let(:facts) {{
      :operatingsystem => 'Debian',
      :osfamily => 'Debian',
      :lsbdistcodename => 'wheezy',
      :lsbdistid => 'Debian',
    }}
    let(:version) { '2012.10.r8.debian7' }
    let(:params) {{
      :package_ensure => version
    }}

    it { should contain_package('fhgfs-meta').with({
      'ensure' => version
    }) }
  end

  it { should contain_file('/etc/fhgfs/meta.interfaces').with({
    'ensure'  => 'present',
    'owner'   => user,
    'group'   => group,
    'mode'    => '0755',
  }).with_content(/eth0/) }

  context 'interfaces file' do
    let(:params) {{
      :interfaces      => ['eth0', 'ib0'],
      :interfaces_file => '/etc/fhgfs/meta.itf',
      :user            => user,
      :group           => group,
    }}

    it { should contain_file('/etc/fhgfs/meta.itf').with({
      'ensure'  => 'present',
      'owner'   => user,
      'group'   => group,
      'mode'    => '0755',
    }).with_content(/ib0/) }


    it { should contain_file(
        '/etc/fhgfs/fhgfs-meta.conf'
      ).with_content(/connInterfacesFile(\s+)=(\s+)\/etc\/fhgfs\/meta.itf/)
    }
  end

  it { should contain_file(
    '/etc/fhgfs/fhgfs-meta.conf'
  ).with_content(/logLevel(\s+)=(\s+)3/) }

  context 'changing log level' do
    let(:params) {{
      :log_level => 5,
    }}

    it { should contain_file(
      '/etc/fhgfs/fhgfs-meta.conf'
    ).with_content(/logLevel(\s+)=(\s+)5/) }
  end

  context 'hiera should override defaults' do
    let(:hiera_data) {{
      'fhgfs::mgmtd_host' => '192.168.1.1',
    }}

    it {
      should contain_file(
        '/etc/fhgfs/fhgfs-meta.conf'
      ).with_content(/sysMgmtdHost(\s+)=(\s+)192.168.1.1/)
    }
  end

end
