# Class: fhgfs::client
#
# This module manages FhGFS client
#
class fhgfs::client (
  $version = $fhgfs::params::version,
  $mounts  = 'puppet:///private/fhgfs/fhgfs-mounts.conf',
) inherits fhgfs {

  package { 'kernel-devel' :
    ensure   => present,
  }
  package { 'fhgfs-helperd':
    ensure   => $version,
  }
  package { 'fhgfs-client':
    ensure   => $version,
    require  => Package['kernel-devel'],
  }
  service { 'fhgfs-helperd':
    ensure   => running,
    enable   => true,
    require  => Package['fhgfs-helperd'],
  }
  file { '/etc/fhgfs/fhgfs-mounts.conf':
    require => Package['fhgfs-client'],
    source  => $mounts,
  }
  service { 'fhgfs-client':
    enable   => true,
    require  => [ Package['fhgfs-client'], Service['fhgfs-helperd'],
                  File['/etc/fhgfs/fhgfs-mounts.conf']
              ],
  }
}
