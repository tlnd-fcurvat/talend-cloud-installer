require 'spec_helper_acceptance'

describe 'role::nexus' do
  let(:pp) do
    <<-EOS
        include "role::nexus"
    EOS
  end

  it_behaves_like 'a idempotent resource'
end
