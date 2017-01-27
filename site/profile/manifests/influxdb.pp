#
# Sets up the influxdb instance
#
class profile::influxdb (

  $influxdb_datapath = '/var/lib/influxdb',
  $storage_device    = undef,
  $service_enable    = true,

) {

  require ::profile::common::packages
  include ::logrotate
  include ::profile::common::concat
  # FIXME rework cloudwatch to add defines and so manage easily each mount in each profiles
  include ::profile::common::cloudwatch
  include ::profile::common::cloudwatchlogs

  profile::register_profile { 'influxdb': }

  if $storage_device {
    class { '::profile::common::mount_device':
      device  => $storage_device,
      path    => $influxdb_datapath,
      options => 'noatime,nodiratime,noexec',
      before  => Class['::influxdb::server']
    }
  }

  class { '::influxdb::server':
    service_enabled           => $service_enable,
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
