require 'spec_helper'

describe 'fhgfs::admon' do
  let(:facts) {{
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
  }}

  let(:user) { 'fhgfs' }
  let(:group) { 'fhgfs' }

  it { should contain_package('fhgfs-utils') }
  it { should contain_service('fhgfs-admon').with(
      :ensure => 'running',
      :enable => true
  ) }

  it { should contain_file('/etc/fhgfs/fhgfs-admon.conf').with({
    'ensure'  => 'present',
    'owner'   => user,
    'group'   => group,
    'mode'    => '0755',
    'require' => 'Package[fhgfs-admon]',
  }) }

  # depends on hiera, which is not correctly setted up in tests
  it { should contain_file('/etc/fhgfs/fhgfs-admon.conf').with_content(
    /databaseFile(\s+)=(\s+)\/var\/lib\/fhgfs\/fhgfs\-admon.db/
  ) }


  context 'with given version' do
    let(:version) { '2012.10.r8.debian7' }
    let(:params) {{
      :package_ensure => version
    }}

    it { should contain_package('fhgfs-admon').with({
      'ensure' => version
    }) }
  end

  context 'setting mgmtd host' do
    let(:params){{
      :mgmtd_host => '192.168.1.1',
      :db_file    => '/var/lib/fhgfs/admon.db',
    }}

    it { should contain_file('/etc/fhgfs/fhgfs-admon.conf').with_content(
      /sysMgmtdHost(\s+)=(\s+)192.168.1.1/
    ) }

    it { should contain_file('/etc/fhgfs/fhgfs-admon.conf').with_content(
      /databaseFile(\s+)=(\s+)\/var\/lib\/fhgfs\/admon.db/
    ) }
  end

end
