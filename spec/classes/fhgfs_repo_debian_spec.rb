require 'spec_helper'

describe 'fhgfs::repo::debian' do
  let(:m_version) { 'fhgfs_2012.10'}
  let(:params) {{
      :package_source => 'fhgfs',
      :manage_repo    => true,
      :major_version  => m_version,
  }}

  shared_examples 'debian_apt_repo' do |os, codename|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
    }}

    it { should contain_exec(
      'apt_get_update_for_fhgfs'
      ).with_command('/usr/bin/apt-get update')
    }

    it { should contain_apt__source('fhgfs').with({
      'location'            => "http://www.fhgfs.com/release/#{m_version}",
      'repos'               => 'non-free',
      'release'             => release,
      })
    }

  end

  context 'install apt-repo deb6' do
    let(:release) { 'deb6' }

    it_behaves_like 'debian_apt_repo', 'Debian', 'squeeze'
  end

  context 'install apt-repo deb7' do
    let(:release) { 'deb7' }

    it_behaves_like 'debian_apt_repo', 'Debian', 'wheezy'
    it_behaves_like 'debian_apt_repo', 'Ubuntu', 'precise'
  end

end
