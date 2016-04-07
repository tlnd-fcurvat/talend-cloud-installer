# puppet_branch.rb
Facter.add("puppet_branch") do
  if File.exists?('/etc/sysconfig/puppetBranch')
    setcode do
      artifacts = File.read('/etc/sysconfig/puppetBranch').chomp
    end
  else
    nil
  end
end
