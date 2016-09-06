class profile::postgresql::install {

  class { 'postgresql::globals':
    encoding            => 'UTF8',
    locale              => 'en_NG',
    manage_package_repo => true,
  }

  class { 'postgresql::server':
    listen_addresses  => '*',
    service_ensure    => $profile::postgresql::service_ensure,
    service_manage    => true,
  }

  contain ::postgresql::server
  contain ::postgresql::client

}
