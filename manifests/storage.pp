# Class: fhgfs::storage
#
# This module manages FhGFS storage service
#
class fhgfs::storage (
  $enable            = true,
  $storage_directory = $fhgfs::storage_directory,
  $mgmtd_host        = $fhgfs::mgmtd_host,
  $log_dir           = $fhgfs::log_dir,
  $log_level         = 3,
  $user              = $fhgfs::user,
  $group             = $fhgfs::group,
  $package_ensure    = $fhgfs::package_ensure,
  $interfaces        = ['eth0'],
  $interfaces_file   = '/etc/fhgfs/storage.interfaces',
) inherits fhgfs {

  require fhgfs::install
  validate_array($interfaces)

  package { 'fhgfs-storage':
    ensure => $package_ensure,
  }

  file { $storage_directory:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    recurse => true,
  }

  file { $interfaces_file:
    ensure => present,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    content => template('fhgfs/interfaces.erb'),
  }

  file { '/etc/fhgfs/fhgfs-storage.conf':
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    content => template('fhgfs/fhgfs-storage.conf.erb'),
    require => [
      File["$interfaces_file"],
      Package['fhgfs-storage'],
    ],
  }

  service { 'fhgfs-storage':
    ensure    => running,
    enable    => $enable,
    hasstatus  => true,
    hasrestart => true,
    require   => Package['fhgfs-storage'],
    subscribe => [
      File['/etc/fhgfs/fhgfs-storage.conf'],
      File["$interfaces_file"],
    ],
  }
}
