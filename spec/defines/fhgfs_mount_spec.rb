require 'spec_helper'

describe 'fhgfs::mount' do

  let(:facts) {{
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
    :lsbdistid => 'Debian',
  }}

  let(:title) { '/mnt/share' }

  let(:params) {{
    :cfg   => '/etc/fhgfs/fhgfs-clients.conf',
    :mnt   => '/mnt/share',
  }}

  it { should contain_file('/etc/fhgfs/fhgfs-mounts.conf').with({
      'ensure'  => 'present',
      'mode'    => '0755',
  })
  # testing file_line doesn't work this way
  #.with_content('/mnt/share /etc/fhgfs/fhgfs-clients.conf')
}

end
