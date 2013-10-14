# Class: fhgfs::storage
#
# This module manages FhGFS storage service
#
class fhgfs::storage (
  $enable            = true,
  $storage_directory = $fhgfs::storage_directory,
  $mgmtd_host        = $fhgfs::mgmtd_host,
  $version           = $fhgfs::version,
  $log_dir           = $fhgfs::log_dir,
  $user              = $fhgfs::user,
  $group             = $fhgfs::group,
) inherits fhgfs {

  require fhgfs::install

  package { 'fhgfs-storage':
    ensure => $version,
  }

  file { $storage_directory:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    recurse => true,
  }

  file { '/etc/fhgfs/fhgfs-storage.conf':
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    content => template('fhgfs/fhgfs-storage.conf.erb'),
    require => Package['fhgfs-storage'],
  }

  service { 'fhgfs-storage':
    ensure    => running,
    enable    => $enable,
    require   => Package['fhgfs-storage'],
    subscribe => File['/etc/fhgfs/fhgfs-storage.conf'];
  }
}
