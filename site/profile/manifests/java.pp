#
# Wraps the java module
#
class profile::java {
  require ::java

  create_resources(
    Package,
    hiera_hash('profile::java::packages', {})
  )
}

