# Class: fhgfs::install
#
# This module manages FhGFS basic packages installation
#
class fhgfs::install(
  $manage_repo    = hiera('fhgfs::manage_repo', $fhgfs::manage_repo),
  $package_source = hiera('fhgfs::package_source', $fhgfs::package_source),
  $log_dir        = hiera('fhgfs::log_dir', $fhgfs::log_dir),
  $user           = hiera('fhgfs::user', $fhgfs::user),
  $group          = hiera('fhgfs::group', $fhgfs::group),
  ) inherits fhgfs {

  class { 'fhgfs::repo':
    manage_repo    => $manage_repo,
    package_source => $package_source,
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

  # make sure log directory exists
  ensure_resource('file', $log_dir, {
    'ensure' => directory,
    owner   => $user,
    group   => $group,
    recurse => true,
    require => Anchor['fhgfs::user'],
  })

}
