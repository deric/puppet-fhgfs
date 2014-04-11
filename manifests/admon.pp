# Class: fhgfs::admon
#
# This module manages FhGFS admon service
#
class fhgfs::admon (
  $enable            = true,
  $mgmtd_host        = $fhgfs::mgmtd_host,
  $db_file           = $fhgfs::admon_db_file,
  $log_dir           = $fhgfs::log_dir,
  $log_level         = 2,
  $user              = $fhgfs::user,
  $group             = $fhgfs::group,
  $package_ensure    = hiera('fhgfs::package_ensure', $fhgfs::package_ensure),
) inherits fhgfs {

  require fhgfs::install

  package { 'fhgfs-admon':
    ensure => $package_ensure,
  }

  file { '/etc/fhgfs/fhgfs-admon.conf':
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    content => template('fhgfs/fhgfs-admon.conf.erb'),
    require => Package['fhgfs-admon'],
  }

  if $package_ensure != 'absent' {
    service { 'fhgfs-admon':
      ensure    => running,
      enable    => $enable,
      hasstatus  => true,
      hasrestart => true,
      require   => Package['fhgfs-admon'],
      subscribe => File['/etc/fhgfs/fhgfs-admon.conf'];
    }
  }
}
