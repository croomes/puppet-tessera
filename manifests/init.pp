# == Class: tessera
#
# Full description of class tessera here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class tessera (
  $root_dir    = '/opt/tessera',
  $packages    = $::tessera::params::packages,
  $source_repo = 'https://github.com/urbanairship/tessera.git',
  $port        = '8080',
  $user        = 'root',
  $init_style  = $::tessera::params::init_style,
) inherits tessera::params {

  # validate parameters here

  class { 'tessera::install': } ->
  class { 'tessera::config': } ~>
  class { 'tessera::service': } ->
  Class['tessera']
}
