# Class: fhgfs::client
#
# This module manages FhGFS client
#
class fhgfs::meta (
  $enable         = true,
  $meta_directory = $fhgfs::meta_directory,
  $mgmtd_host     = $fhgfs::mgmtd_host,
  $version        = $fhgfs::version,
  $user           = $fhgfs::user,
  $group          = $fhgfs::group,
) inherits fhgfs {

  require fhgfs::install

  package { 'fhgfs-meta':
    ensure => $version,
  }

  file { '/etc/fhgfs/fhgfs-meta.conf':
    require => Package['fhgfs-meta'],
    ensure  => 'present',
    owner   => $user,
    group   => $group,
    mode    => '0755',
    content => template('fhgfs/fhgfs-meta.conf.erb'),
  }

  service { 'fhgfs-meta':
    ensure    => running,
    enable    => $enable,
    require   => Package['fhgfs-meta'],
    subscribe => File['/etc/fhgfs/fhgfs-meta.conf'];
  }
}
