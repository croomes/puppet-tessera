# == Class tessera::params
#
# This class is meant to be called from tessera
# It sets variables according to platform
#
class tessera::params {

  case $::osfamily {
    'Debian': {
      $packages   = ['tessera']
      $init_style = 'upstart'
    }
    'RedHat', 'Amazon': {
      $packages = ['tessera']
      if ($::operatingsystem != 'Fedora'
          and versioncmp($::operatingsystemrelease, '7') >= 0)
        or ($::operatingsystem == 'Fedora'
          and versioncmp($::operatingsystemrelease, '15') >= 0) {
          $init_style = 'systemd'
      }
      else {
        fail("${::osfamily} ${::operatingsystemrelease} is not currently supported.")
      }
    }
    default: {
      fail("${::osfamily} not supported")
    }
  }
}
