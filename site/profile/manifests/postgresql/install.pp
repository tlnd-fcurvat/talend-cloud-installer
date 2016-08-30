class profile::postgresql::install {

  class { 'postgresql::globals':
    encoding            => 'UTF8',
    locale              => 'en_NG',
    manage_package_repo => true,
  }

  class { 'postgresql::server':
    listen_addresses  => '*',
    postgres_password => $profile::postgresql::password,
    service_ensure    => $profile::postgresql::service_ensure,
    service_enable    => $profile::postgresql::service_enable,
    service_manage    => true,
  }

  contain ::postgresql::server
  contain ::postgresql::client

}
