shared_examples 'profile::activemq' do
	describe service('activemq') do
		it { should be_enabled }
		it { should be_running }
	end

	describe port(8161) do
		it { should be_listening }
	end

	describe port(5432) do
		it { should be_listening }
	end
end
