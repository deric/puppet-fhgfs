# Class: fhgfs::install
#
# This module manages FhGFS basic packages installation
#
class fhgfs::install(
  $manage_repo    = $fhgfs::manage_repo,
  $package_source = $fhgfs::package_source,
  $version        = $fhgfs::version,
  $log_dir        = $fhgfs::log_dir,
  $user           = $fhgfs::user,
  $group          = $fhgfs::group,
  ) inherits fhgfs {

  class { 'fhgfs::repo':
    manage_repo    => $manage_repo,
    package_source => $package_source,
    version        => $version,
  }

  anchor { 'fhgfs::user' : }

  user { 'fhgfs':
    ensure => present,
    before => Anchor['fhgfs::user'],
  }

  group { 'fhgfs':
    ensure => present,
    before => Anchor['fhgfs::user'],
  }

  file { $log_dir:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    recurse => true,
    require => Anchor['fhgfs::user'],
  }

  file { '/etc/fhgfs/fhgfs-client.conf':
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => Package['fhgfs-utils'],
    content => template('fhgfs/fhgfs-client.conf.erb'),
  }

}
