# Class: fhgfs::client
#
# This module manages FhGFS client
#
class fhgfs::mgmtd (
  $enable                        = false,
  $mgmtd_directory               = $fhgfs::mgmtd_directory,
  $client_auto_remove_mins       = $fhgfs::client_auto_remove_mins,
  $meta_space_low_limit          = $fhgfs::meta_space_low_limit,
  $meta_space_emergency_limit    = $fhgfs::meta_space_emergency_limit,
  $storage_space_low_limit       = $fhgfs::storage_space_low_limit,
  $storage_space_emergency_limit = $fhgfs::storage_space_emergency_limit,
  $version                       = $fhgfs::version,
  ){

  require fhgfs::install

  package { 'fhgfs-mgmtd':
    ensure  => $version,
  }

  file { '/etc/fhgfs/fhgfs-mgmtd.conf':
    require => Package['fhgfs-mgmtd'],
    content => template('fhgfs/fhgfs-mgmtd.conf.erb'),
  }

  service { 'fhgfs-mgmtd':
    ensure    => running,
    enable    => $enable,
    require   => Package['fhgfs-mgmtd'],
    subscribe => File['/etc/fhgfs/fhgfs-mgmtd.conf'];
  }
}
