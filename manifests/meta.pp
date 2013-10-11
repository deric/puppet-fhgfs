# Class: fhgfs::client
#
# This module manages FhGFS client
#
class fhgfs::meta (
  $enable         = false,
  $meta_directory = $fhgfs::params::meta_directory,
  $mgmtd_host     = $fhgfs::params::mgmtd_host,
  $version        = $fhgfs::params::version,
) inherits fhgfs {

  package { 'fhgfs-meta':
    ensure => $version,
  }

  file { '/etc/fhgfs/fhgfs-meta.conf':
    require => Package['fhgfs-meta'],
    content => template('fhgfs/fhgfs-meta.conf.erb'),
  }

  service { 'fhgfs-meta':
    ensure    => running,
    enable    => $enable,
    require   => Package['fhgfs-meta'],
    subscribe => File['/etc/fhgfs/fhgfs-meta.conf'];
  }
}
