shared_examples 'profile::common::ssm' do

  describe package('amazon-ssm-agent') do
    it { should be_installed }
  end

end
