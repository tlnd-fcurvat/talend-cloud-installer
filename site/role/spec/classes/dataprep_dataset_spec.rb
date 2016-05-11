require 'spec_helper'

describe 'role::dataprep_dataset' do

  context 'with defaults' do
  let(:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '7.1'
    }}
    it { should compile }
  end

end

