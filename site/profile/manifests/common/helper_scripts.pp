class profile::common::helper_scripts {

  file {
    '/usr/local/sbin/pnow':
      source => 'puppet:///modules/profile/usr/local/sbin/pnow',
      mode   => '0755';

    '/usr/local/sbin/pupdate':
      content => template('profile/usr/local/sbin/pupdate.erb'),
      mode    => '0755';
  }
}

