module Puppet::Parser::Functions

  newfunction(:json_decode, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|

    Decode a json string

    Usage:

      $decodestring = json_decode('[1, 2, 3]')

  ENDHEREDOC

    require 'json'

    raise Puppet::ParseError, ("json_decode(): Wrong number of arguments (#{args.length}; must be = 1)") unless args.length == 1

    result = JSON.parse(args[0])

    return result
  end
end
