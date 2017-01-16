class profile::mongodb::roles (

  $db_address = 'admin',
  $roles      = {},

) {

  if $profile::mongodb::service_ensure == 'running' {
    $instanceLogicalId = pick($::cfn_resource_name, $::ec2_userdata, '')
    if $instanceLogicalId =~ /InstanceA/ {
      create_resources('profile::mongodb::role', $roles)
    }
  }

}
