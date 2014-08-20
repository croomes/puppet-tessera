# == Class tessera::service
#
# This class is meant to be called from tessera
# It ensure the service is running
#
class tessera::service {
  include tessera::params

  # service { $tessera::params::service_name:
  #   ensure     => running,
  #   enable     => true,
  #   hasstatus  => true,
  #   hasrestart => true,
  # }
}
