# Class: fhgfs::meta
#
# This module manages FhGFS meta service
#
class fhgfs::meta (
  $enable         = true,
  $meta_directory = $fhgfs::meta_directory,
  $mgmtd_host     = $fhgfs::mgmtd_host,
  $log_dir        = $fhgfs::log_dir,
  $user           = $fhgfs::user,
  $group          = $fhgfs::group,
  $package_ensure = $fhgfs::package_ensure,
) inherits fhgfs {

  require fhgfs::install

  package { 'fhgfs-meta':
    ensure => $package_ensure,
  }

  file { '/etc/fhgfs/fhgfs-meta.conf':
    ensure  => $package_ensure,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    content => template('fhgfs/fhgfs-meta.conf.erb'),
    require => Package['fhgfs-meta'],
  }

  service { 'fhgfs-meta':
    ensure    => running,
    enable    => $enable,
    require   => Package['fhgfs-meta'],
    subscribe => File['/etc/fhgfs/fhgfs-meta.conf'];
  }
}
