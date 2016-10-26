module Puppet::Parser::Functions
  #
  # Returns ec2-like hostname of the ipaddress
  #
  # ip2ec2hostname(10.72.5.111) # returns ip-10-72-5-111
  newfunction(:ip2ec2hostname, :type => :rvalue) do |args|
    if args[0].class == Array then
      args[0].map { |x| "ip-#{x.tr('.', '-')}" }
    elsif
      "ip-#{args[0].tr('.', '-')}"
    end
  end
end
