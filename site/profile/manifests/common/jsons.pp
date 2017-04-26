class profile::common::jsons (

  $files = undef,

) {

  create_resources('profile::common::json', pick_default($files, {}))

}
