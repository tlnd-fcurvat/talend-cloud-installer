# sytem_profile.rb
Facter.add("puppet_profile") do
  if File.exists?('/etc/sysconfig/puppetProfile')
    setcode do
      artifacts = File.readlines('/etc/sysconfig/puppetProfile').map {|l| l.chomp }.sort.join(' ')
    end
  else
    nil
  end
end
