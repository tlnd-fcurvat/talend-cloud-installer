#
# InfluxDB instance role
#
class role::influxdb {

  include ::profile::base
  include ::profile::influxdb

  role::register_role { 'influxdb': }

}
