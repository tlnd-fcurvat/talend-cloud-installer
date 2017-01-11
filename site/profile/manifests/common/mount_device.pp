class profile::common::mount_device (

  $device    = undef,
  $path      = undef,
  $options   = 'noatime,nodiratime',

) {

  if $device and $path {
    filesystem { "Filesystem ${device}":
      name    => $device,
      ensure  => present,
      fs_type => 'xfs',
      options => '-f'
    } ->
    exec { "mkdir ${path}":
      command => "mkdir -p ${path}",
      creates => $path,
      path    => '/bin:/usr/bin'
    } ->
    exec { "Fix readahead ${device}":
      command => "/sbin/blockdev --setra 32 ${device}",
      unless  => "/sbin/blockdev --getra ${device} | grep -w 32"
    } ->
    mount { "Mounting ${path} to ${device}":
      name    => $path,
      ensure  => mounted,
      device  => $device,
      fstype  => 'xfs',
      options => $options,
      atboot  => true
    }
  } else {
    notice("Skipping mounting device '${device}' to path '${path}' : device or path is empty")
  }

}
