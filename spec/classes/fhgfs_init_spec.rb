require 'spec_helper'

describe 'fhgfs::init' do

  let(:facts) {{
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
    :lsbdistid => 'Debian',
  }}

  it { should compile.with_all_deps }
end
