# puppet config

class fhgfs::install(
  $manage_repo    = $fhgfs::manage_repo,
  $package_source = $fhgfs::package_source,
  $version        = $fhgfs::version,
  ) {

  class { 'fhgfs::repo':
    manage_repo    => $manage_repo,
    package_source => $package_source,
    version        => $version,
  }

  file { '/etc/fhgfs/fhgfs-client.conf':
    require => Package['fhgfs-utils'],
    content => template('fhgfs/fhgfs-client.conf.erb'),
  }

}
