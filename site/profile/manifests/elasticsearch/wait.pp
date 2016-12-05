#
# Waits for the elasticsearch service to start
#
class profile::elasticsearch::wait (

  $status = running,

) {

  require ::profile::elasticsearch::setup
  require ::profile::common::packages

  if $status == 'running' {
    exec { 'waiting for Elasticsearch to start':
      command => '/usr/bin/wget --spider --tries 15 --retry-connrefused "http://localhost:9200/?pretty"'
    }
  }

}
