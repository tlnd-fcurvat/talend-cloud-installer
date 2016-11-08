shared_examples 'profile::common::packages' do |packages=[]|

  (packages + %w(cloud-init)).each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end

  %w(hiera-eyaml hiera-eyaml-kms aws-sdk package_cloud).each do |p|
    describe package(p) do
      it { should be_installed.by('gem') }
    end
  end

end
