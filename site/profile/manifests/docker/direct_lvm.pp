#
# Sets up Docker Storage Backend
# @see: https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/#configure-direct-lvm-mode-for-production
#
class profile::docker::direct_lvm (

  $storage_device         = undef,
  $vg_name                = 'docker',
  $lv_metadata_name       = 'metadata',
  $lv_data_name           = 'data',
  $lv_metadata_percentage = '1',   # Note: 95 + 1 != 100, because we have autoextension configured.
  $lv_data_percentage     = '95',  # Leaving this free space allows for auto expanding of either the data or metadata if space runs low.

) {

  physical_volume { $storage_device:
    ensure => present,
  } ->
  volume_group { $vg_name:
    ensure           => present,
    physical_volumes => $storage_device,
  } ->
  logical_volume { $lv_metadata_name:
    ensure       => present,
    volume_group => $vg_name,
    extents      => "${lv_metadata_percentage}%VG"
  } ->
  logical_volume { $lv_data_name:
    ensure       => present,
    volume_group => $vg_name,
    extents      => "${lv_data_percentage}%VG"
  }

  $lv_convert_lock = '/var/tmp/lv_convert_thin_pool'
  $lv_change_lock = '/var/tmp/lv_change_thin_pool'

  $lv_convert_cmd = "lvconvert -y --zero n -c 512K \
    --thinpool ${vg_name}/${lv_data_name} \
    --poolmetadata ${vg_name}/${lv_metadata_name} \
    && touch ${lv_convert_lock}"

  exec { 'Convert the pool to a thin pool':
    command => $lv_convert_cmd,
    creates => $lv_convert_lock,
    path    => ['/usr/bin', '/usr/sbin'],
    require => [Logical_volume[$lv_data_name], Logical_volume[$lv_metadata_name]],
  } ->
  file { 'Create lvm thin pool profile':
    path    => '/etc/lvm/profile/docker-thinpool.profile',
    content => "activation { \
                thin_pool_autoextend_threshold = 80 \
                thin_pool_autoextend_percent = 20 \
                }",
  } ->
  exec { 'Apply thin pool lvm profile':
    command => "lvchange --metadataprofile docker-thinpool ${vg_name}/${lv_data_name} && touch ${lv_change_lock}",
    creates => $lv_change_lock,
    path    => ['/usr/bin', '/usr/sbin'],
  }

}
