require 'spec_helper'

describe 'fhgfs::mgmtd' do
  shared_examples 'debian-mgmtd' do |os, codename|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
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
    #it_behaves_like 'debian-mgmtd', 'Debian', 'squeeze'
    it_behaves_like 'debian-mgmtd', 'Debian', 'wheezy'
    #it_behaves_like 'debian-mgmtd', 'Ubuntu', 'precise'
  end

end
