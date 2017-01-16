require 'json'

module Puppet::Parser::Functions
  newfunction(:to_json_ex, :type => :rvalue) do |args|
    obj = args[0]

    return obj.to_json
  end
end
