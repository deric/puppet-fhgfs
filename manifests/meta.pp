# Class: fhgfs::meta
#
# This module manages FhGFS meta service
#
class fhgfs::meta (
  $enable          = true,
  $meta_directory  = $fhgfs::meta_directory,
  $mgmtd_host      = $fhgfs::mgmtd_host,
  $log_dir         = $fhgfs::log_dir,
  $log_level       = 3,
  $user            = $fhgfs::user,
  $group           = $fhgfs::group,
  $package_ensure  = $fhgfs::package_ensure,
  $interfaces      = ['eth0'],
  $interfaces_file = '/etc/fhgfs/meta.interfaces',
) inherits fhgfs {

  require fhgfs::install
  validate_array($interfaces)

  package { 'fhgfs-meta':
    ensure => $package_ensure,
  }

  file { $interfaces_file:
    ensure => present,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    content => template('fhgfs/interfaces.erb'),
  }

  file { '/etc/fhgfs/fhgfs-meta.conf':
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    content => template('fhgfs/fhgfs-meta.conf.erb'),
    require => [
      File["$interfaces_file"],
      Package['fhgfs-meta'],
    ],
  }

  service { 'fhgfs-meta':
    ensure    => running,
    enable    => $enable,
    hasstatus  => true,
    hasrestart => true,
    require   => Package['fhgfs-meta'],
    subscribe => [
      File['/etc/fhgfs/fhgfs-meta.conf'],
      File["$interfaces_file"]
    ],
  }
}
