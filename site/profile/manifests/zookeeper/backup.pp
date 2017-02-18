#
# Sets up zookeeper backups
#

class profile::zookeeper::backup (
	$backup_bucket = $::zookeeper::backup_bucket_name
) {

  $is_leader = generate("/bin/bash","-c","echo stat | nc localhost 2181 | grep leader; echo \$?")
  if $is_leader == 0 {
    $cron_ensure = 'present'
  } else {
    $cron_ensure = 'absent'
  }
  package {
    'pyasn1' :
        ensure          => present,
        provider        => 'pip';
  }
  $backup_buckets = split(regsubst($backup_bucket, '[\s\[\]\"]', '', 'G'), ',')
  $backup_bucket_name = $backup_buckets[0] 

  file {

  '/usr/local/bin/zookeeper_backup.sh':
      content => template('profile/usr/local/bin/zookeeper_backup.sh.erb'),
      mode   => '0755',
      owner  => 'root',
      require => Package[awscli];

  }

  '/usr/local/bin/zookeeper_restore.sh':
      content => template('profile/usr/local/bin/zookeeper_restore.sh.erb'),
      mode   => '0755',
      owner  => 'root',
      require => Package[awscli];

  }

  cron {
    'backup_zk':
      ensure  => $cron_ensure,
      command => '/usr/bin/flock -n /var/run/zk_backup.lock /usr/local/bin/zookeeper_backup.sh',
      hour    => $backup_cron_hour,
      minute  => $backup_cron_minute,
      require => Package[awscli]
  }


}
