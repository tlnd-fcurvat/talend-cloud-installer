require 'spec_helper'

describe 'role::dataprep_dataset' do
  it_behaves_like 'profile::base'
  it_behaves_like 'role::defined', 'dataprep_dataset'

  describe service('dataprep-dataset') do
    it { should be_running }
  end

  describe 'should have java process with correct arguments' do
    subject { command('/usr/bin/pgrep -a java').stdout }
    it { should include '/opt/talend/dataprep' }
  end
end
