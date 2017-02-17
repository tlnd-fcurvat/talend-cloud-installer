#
# Sets up a hosts entry and its aliases
#
define profile::common::hosts_entry (

  $group   = undef,
  $aliases = [],
  $total   = 1,

) {

  $parts = split($name, '=')
  $index = $parts[0]
  $entry = $parts[1]

  $_aliases = split(regsubst(join($aliases, '{{{'), '\%index\%', $index, 'G'), '{{{')

  host { "${group}-${entry}-${index}":
    ip           => $entry,
    host_aliases => $_aliases,
  }

}
