#
# Sets up elasticsearch backups
#

class profile::elasticsearch::backup (
        $backup_bucket = $::backup_bucket
) {

  $backup_buckets = split(regsubst($backup_bucket, '[\s\[\]\"]', '', 'G'), ',')
  $backup_bucket_name = $backup_buckets[0]

  file {
    '/usr/local/bin/elasticsearch_backup.sh':
      content => template('profile/usr/local/bin/elasticsearch_backup.sh.erb'),
      mode   => '0755',
      owner  => 'root'
  }

  cron {
    'elk_backup':
      ensure  => 'present',
      command => "/usr/bin/flock -n /var/run/elk_backup.lock /usr/local/bin/elasticsearch_backup.sh 2>&1 | logger -t elk-backup",
      hour    => $backup_cron_hour,
      minute  => $backup_cron_minute
  }

}
