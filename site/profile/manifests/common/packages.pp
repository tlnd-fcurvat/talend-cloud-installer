#
# Installs hiera-defined common_packages
#
class profile::common::packages {

  require ::profile::common::packagecloud_repos

  create_resources(
    Package,
    hiera_hash('common_packages', {})
  )

}
