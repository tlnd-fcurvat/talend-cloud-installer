#
# Maintains the hosts file using list of entries and their aliases.
#
# Parameters:
#
#   [*entries*]     - List of host entries in a form of comma-separated string, array
#     or a json-like string for example: '[ "10.0.2.12", "10.0.2.23" ]'
#
#   [*aliases*]     - Array of templates (strings) for every host entry.
#     Every template can have the %index% placeholder which will be substituted
#     with zero-based index of an entry in the entries array.
#     For example, [ "the-first-alias%index%.com", "the-second-alias%index%.com" ]
#
#
define profile::common::hosts_entries (

  $entries = undef,
  $aliases = [],

) {

  if is_string($entries) {
    $_entries = split(regsubst($entries, '[\s\[\]\"]', '', 'G'), ',')
  } else {
    $_entries = $entries
  }

  $_pairs = zip(
    prefix(range(0, size($_entries) - 1), ' '),
    prefix($_entries, '=')
  )
  $_entry_pairs = delete(split(join($_pairs, ''), ' '), '')

  profile::common::hosts_entry { $_entry_pairs:
    group   => $name,
    aliases => $aliases,
    total   => size($_entry_pairs)
  }

}
