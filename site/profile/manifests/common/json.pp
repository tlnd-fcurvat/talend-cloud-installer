#
# Creates a json file using provided data
#
define profile::common::json (

  $filename   = $name,
  $foldername = '/tmp',
  $data       = {}

) {

  exec { "Ensure json file directory : ${name}":
    command => "mkdir -p ${foldername}",
    creates => $foldername,
    path    => '/bin:/usr/bin'
  } ->
  file { "Create the json file : ${name}":
    path    => "${foldername}/${filename}",
    content => inline_template('<%= @data.to_json %>')
  }

}
