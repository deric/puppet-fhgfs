require 'spec_helper'
require 'shared_contexts'

describe 'fhgfs::meta' do
  let(:facts) {{
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
  }}


  shared_examples 'debian-meta' do |os, codename|
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

    #it_behaves_like 'debian-meta', 'Debian', 'squeeze'
    it_behaves_like 'debian-meta', 'Debian', 'wheezy'
    #it_behaves_like 'debian-meta', 'Ubuntu', 'precise'
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

 # context 'with hiera' do
 #    include_context 'hieradata'
 #
 #    let(:hiera_data) { {
 #      'fhgfs::mgmtd_host' => '192.168.1.1',
 #    } }
 #
 #   it {
 #     should contain_file(
 #       '/etc/fhgfs/fhgfs-meta.conf'
 #     ).with_content(/sysMgmtdHost(\s+)=(\s+)192.168.1.1/)
 #   }
 # end

end
