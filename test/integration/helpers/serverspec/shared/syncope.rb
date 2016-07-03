shared_examples 'profile::web::syncope' do
  describe port(8080) do
    it { should be_listening }
  end
end
