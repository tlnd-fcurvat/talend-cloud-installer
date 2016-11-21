shared_examples 'profile::docker_host' do

  it_behaves_like 'profile::defined', 'docker_host'

  describe package('docker-engine') do
    it { is_expected.to be_installed }
  end

  describe docker_container('registry') do
    it { should be_running }
  end

  describe port(5000) do
    it { should be_listening }
  end

end
