shared_examples 'profile::postgresql' do

  it_behaves_like 'profile::defined', 'postgresql'

  describe package('postgresql-server') do
    it { is_expected.to be_installed }
  end
  describe package('postgresql') do
    it { is_expected.to be_installed }
  end

  describe service('postgresql') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(5432) do
    it { should be_listening }
  end

end
