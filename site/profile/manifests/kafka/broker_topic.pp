# Example of hiera conf to call this ressource
# profile::kafka::kafka_topics_config:
#   mytopicwithdefault:
#     replication_factor: 2
#     partitions: 6
#   mytopic:
#     replication_factor: 2
#     partitions: 6
#     topic_options:
#       retention.bytes: 1073741824 #1GB
#       cleanup.policy: 'delete'
#       retention.ms: 18000000 #5 hours
define profile::kafka::broker_topic(
  $ensure             = 'present',
  $zookeeper          = $::profile::kafka::zookeeper_connect,
  $replication_factor = 1,
  $partitions         = 1,
  $topic_options      = {} #https://kafka.apache.org/documentation/#topic-config
) {

  $_zookeeper          = "--zookeeper ${zookeeper}"
  $_replication_factor = "--replication-factor ${replication_factor}"
  $_partitions         = "--partitions ${partitions}"

  $_topic_options  = inline_template('<% unless @topic_options.empty? %><% @topic_options.each do |key, value| %> --config <%= key %>=<%= value %><% end %><% end %>')

  if $ensure == 'present' {
    exec { "create topic ${name}":
      path    => '/usr/bin:/usr/sbin/:/bin:/sbin:/opt/kafka/bin',
      command => "kafka-topics.sh --create ${_zookeeper} ${_replication_factor} ${_partitions} --topic ${name} ${_topic_options}",
      unless  => "kafka-topics.sh --list ${_zookeeper} | grep -x ${name}",
    }
  }
}
