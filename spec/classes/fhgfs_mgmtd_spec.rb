require 'spec_helper'

describe 'fhgfs::mgmtd' do
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

  shared_examples 'debian-mgmtd' do |os, codename|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
      :lsbdistid => 'Debian',
    }}

    let(:params) {{
      :user  => user,
      :group => group,
    }}
    it { should contain_package('fhgfs-mgmtd') }
    it { should contain_package('fhgfs-utils') }

    it { should include_class('fhgfs::repo::debian') }

    it { should contain_service('fhgfs-mgmtd').with(
        :ensure => 'running',
        :enable => true
    ) }
  end

  context 'on debian-like system' do
    it_behaves_like 'debian-mgmtd', 'Debian', 'wheezy'
    it_behaves_like 'debian-mgmtd', 'Ubuntu', 'precise'
  end

  context 'with given version' do
    let(:version) { '2012.10.r8.debian7' }
    let(:params) {{
      :package_ensure => version,
      :user           => user,
      :group          => group,
    }}

    it { should contain_package('fhgfs-mgmtd').with({
      'ensure' => version
    }) }
  end

  it { should contain_file('/etc/fhgfs/mgmtd.interfaces').with({
    'ensure'  => 'present',
    'owner'   => user,
    'group'   => group,
    'mode'    => '0755',
  }).with_content(/eth0/) }

  context 'interfaces file' do
    let(:params) {{
      :interfaces      => ['eth0', 'ib0'],
      :interfaces_file => '/etc/fhgfs/mgmtd.itf',
      :user            => user,
      :group           => group,
    }}

    it { should contain_file('/etc/fhgfs/mgmtd.itf').with({
      'ensure'  => 'present',
      'owner'   => user,
      'group'   => group,
      'mode'    => '0755',
    }).with_content(/ib0/) }


    it { should contain_file(
        '/etc/fhgfs/fhgfs-mgmtd.conf'
      ).with_content(/connInterfacesFile(\s+)=(\s+)\/etc\/fhgfs\/mgmtd.itf/)
    }
  end

  it { should contain_file(
    '/etc/fhgfs/fhgfs-mgmtd.conf'
  ).with_content(/logLevel(\s+)=(\s+)2/) }

  context 'changing log level' do
    let(:params) {{
      :log_level => 5,
    }}

    it { should contain_file(
      '/etc/fhgfs/fhgfs-mgmtd.conf'
    ).with_content(/logLevel(\s+)=(\s+)5/) }
  end

end
