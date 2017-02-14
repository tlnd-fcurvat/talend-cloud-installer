## kafka.pp (kitchen tests only) ##

# This file replace the file site.pp as entrypoint for kafka kitchen test
File { backup => false }

# enable the Puppet 4 behavior today
#
Package {
  allow_virtual => true,
}

# Ensure we have a path set for all possible execs
# This is now limited to unixoid systems
Exec {
  path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin',
}

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.
node default {
  #Currently, we can't easyly test multinodes with kitchen: https://github.com/chef/chef-rfc/blob/master/rfc084-test-kitchen-multi.md
  #Workaround to install zookeeper on the same host in order to make kafka working during kitchen tests
  require 'role::zookeeper'
  include "role::${::puppet_role}"
}
