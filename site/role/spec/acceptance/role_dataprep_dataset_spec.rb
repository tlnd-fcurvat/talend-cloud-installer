require 'spec_helper_acceptance'


describe "role::dataprep_dataset" , :if => fact('hostname').match(/dataprepdataset/) do
  let(:pp) do
    <<-EOS
        class { 'role::dataprep_dataset':
        }
    EOS
  end

  it_behaves_like "a idempotent resource"

  context 'should have dataprep_dataset role configured' do

    it 'should have java process with correct arguments' do
      expect(command('pgrep -a java').stdout).to match /\/opt\/talend\/dataprep\//
    end

  end
end


