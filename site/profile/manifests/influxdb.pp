#
# Sets up the influxdb instance
#
class profile::influxdb (
  $influxdb_datapath = '/var/lib/influxdb',
  $storage_device    = undef
) {

  require ::profile::common::packages
  include ::logrotate
  include ::profile::common::concat
  # FIXME rework cloudwatch to add defines and so manage easily each mount in each profiles
  include ::profile::common::cloudwatch
  include ::profile::common::cloudwatchlogs

  profile::register_profile { 'influxdb': }

  if $storage_device {
    filesystem { $storage_device:
      ensure  => present,
      fs_type => 'xfs',
      options => '-f',
      before  => Class['::influxdb::server']
    }

    #creates parent path if absent
    exec { "mkdir-${influxdb_datapath}":
      command => "mkdir -p ${influxdb_datapath}",
      creates => $influxdb_datapath,
      path    => '/bin:/usr/bin',
      before  => Class['::influxdb::server']
    }

    #configure the disk before mounting
    exec { "fix-readahead-${storage_device}":
      command => "/sbin/blockdev --setra 32 ${storage_device}",
      unless  => "/sbin/blockdev --getra ${storage_device} | grep -w 32",
      require => Filesystem[$storage_device],
    }

    #mount the storage volume, rights will be put by nexus class
    mount { $influxdb_datapath:
      ensure  => 'mounted',
      device  => $storage_device,
      fstype  => 'xfs',
      options => 'noatime,nodiratime,noexec',
      atboot  => true,
      require => [ Filesystem[$storage_device],
                    Exec["mkdir-${influxdb_datapath}"],
                    Exec["fix-readahead-${storage_device}"] ],
      before  => Class['::influxdb::server']
    }
  }


  class { '::influxdb::server':
    version                   => '1.1.1-1',
    meta_dir                  => "${influxdb_datapath}/meta",
    data_dir                  => "${influxdb_datapath}/data",
    wal_dir                   => "${influxdb_datapath}/wal",
    hinted_handoff_dir        => "${influxdb_datapath}/hh",
    http_enabled              => true,
    http_bind_address         => ':8086',
    admin_bind_address        => ':8083',
    monitoring_enabled        => true,
    monitoring_database       => '_internal',
    monitoring_write_interval => '10s'
  }

  contain ::influxdb::server
}
