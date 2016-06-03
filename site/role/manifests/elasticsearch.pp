# Elasticsearch Repository role
#
class role::elasticsearch {

  include ::profile::base
  include ::java
  include ::profile::elasticsearch

  ensure_packages(['wget'])

  exec { 'waiting for Elasticsearch to start':
    command => '/usr/bin/wget --spider --tries 15 --retry-connrefused "http://localhost:9200/?pretty"'
  }

  Class['::java'] ->
  Class['::profile::elasticsearch'] ->
  Package['wget'] ->
  Exec['waiting for Elasticsearch to start']
}
