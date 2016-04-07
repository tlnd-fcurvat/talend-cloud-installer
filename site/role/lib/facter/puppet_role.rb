# sytem_role.rb
Facter.add("puppet_role") do
  if File.exists?('/etc/sysconfig/puppetRole')
    setcode do
      artifacts = File.read('/etc/sysconfig/puppetRole').chomp
    end
  else
    nil
  end
end
