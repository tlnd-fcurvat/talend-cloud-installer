class role::management_proxy {

  include ::profile::base
  include ::nginx
  role::register_role { 'management_proxy': }

}

