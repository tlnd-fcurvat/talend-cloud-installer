class profile::mongodb::users (

  $db_address = 'admin',
  $users      = {},

) {

  if $profile::mongodb::service_ensure == 'running' {
    $instanceLogicalId = pick($::cfn_resource_name, $::ec2_userdata, '')
    if $instanceLogicalId =~ /InstanceA/ {
      create_resources('profile::mongodb::user', $users)
    }
  }

}
