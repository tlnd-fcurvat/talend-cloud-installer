class profile::common::hosts (

  $entries = undef,

) {

  create_resources('profile::common::hosts_entries', $entries)

}
