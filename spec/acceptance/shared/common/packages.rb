shared_examples 'profile::common::packages' do

  %w(hiera-eyaml hiera-eyaml-kms aws-sdk package_cloud).each do |p|
    describe package(p) do
      it { should be_installed.by('gem') }
    end
  end

end
