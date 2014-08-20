# == Class tessera::install
#
class tessera::install (
  $init_style = $tessera::init_style,
) {

  # include tessera::params

  include nodejs
  # include vcsrepo

  # ensure_packages($tessera::packages)

  # vcsrepo { $tessera::root_dir:
  #   ensure   => present,
  #   provider => git,
  #   source   => $tessera::source_repo,
  #   notify   => Exec['tessera_build'],
  # }

  # python::pip { [
  #   "flask==0.10.1",
  #   "flask-sqlalchemy==1.0",
  #   "sqlalchemy==0.9.4",
  #   "requests==2.3.0",
  #   "simplejson==3.5.2",
  #   "inflection==0.2.0",
  #   "tessera-client==0.4.1"
  # ]:
  #   virtualenv  => $root_dir,
  #   environment => ["PYTHONPATH=${root_dir}/lib:${root_dir}/webapp"],
  # }

  python::virtualenv { $tessera::root_dir:
    ensure       => present,
    requirements => "${tessera::root_dir}/requirements.txt",
    systempkgs   => true,
    owner        => $tessera::user,
    group        => $tessera::group,
  }

  nodejs::npm { [
                 "${tessera::root_dir}:grunt",
                 "${tessera::root_dir}:grunt-cli",
                 "${tessera::root_dir}:grunt-contrib-watch",
                 "${tessera::root_dir}:grunt-contrib-concat",
                 "${tessera::root_dir}:grunt-contrib-handlebars",
                 ]:
    ensure  => present,
    require => Class['nodejs'],
  }

  exec { "tessera_build":
    cwd       => $tessera::root_dir,
    user      => $tessera::user,
    group     => $tessera::group,
    command   => "${tessera::root_dir}/node_modules/grunt-cli/bin/grunt",
    logoutput => on_failure,
    require   => Nodejs::Npm["${tessera::root_dir}:grunt-cli"],
  }

  $start_file = $init_style ? {
    'init'    => '/etc/init/tessera',
    'upstart' => '/etc/init/tessera.conf',
    'systemd' => '/lib/systemd/system/tessera.service',
  }

  file { $start_file:
    ensure  => present,
    content => template("tessera/${init_style}.erb"),
  }

}
