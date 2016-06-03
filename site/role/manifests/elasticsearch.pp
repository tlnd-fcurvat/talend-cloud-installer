# Elasticsearch Repository role
#
class role::elasticsearch {

  include ::profile::base
  include java
  include ::profile::elasticsearch

  Class['java'] -> Class['elasticsearch']
}
