require 'spec_helper'

describe 'fhgfs::repo::debian' do
  shared_examples 'debian_apt_repo' do |os, codename|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
    }}

    it { should contain_exec('apt_get_update_for_fhgfs').with_command('/usr/bin/apt-get update') }

  end

  context 'install apt-repo' do
    it_behaves_like 'debian_apt_repo', 'Debian', 'squeeze'
    it_behaves_like 'debian_apt_repo', 'Debian', 'wheezy'
    it_behaves_like 'debian_apt_repo', 'Ubuntu', 'precise'
  end

end
