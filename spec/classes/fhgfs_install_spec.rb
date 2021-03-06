require 'spec_helper'

describe 'fhgfs::install' do
  shared_examples 'debian-install' do |os, codename|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
      :lsbdistid => 'Debian',
    }}

    it { should contain_class('fhgfs::repo') }

    it { should contain_user('fhgfs') }
    it { should contain_group('fhgfs') }
  end

  context 'on debian-like system' do
    let(:user) { 'fhgfs' }
    let(:group) { 'fhgfs' }

    let(:params) {{
      'user'  => user,
      'group' => group,
    }}

    it_behaves_like 'debian-install', 'Debian', 'wheezy'
    it_behaves_like 'debian-install', 'Ubuntu', 'precise'
  end

end
