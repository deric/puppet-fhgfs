# Class: fhgfs::client
#
# This module manages FhGFS mgmtd
#
class fhgfs::mgmtd (
  $enable                        = true,
  $directory                     = '/mgmtd',
  $client_auto_remove_mins       = $fhgfs::client_auto_remove_mins,
  $meta_space_low_limit          = $fhgfs::meta_space_low_limit,
  $meta_space_emergency_limit    = $fhgfs::meta_space_emergency_limit,
  $storage_space_low_limit       = $fhgfs::storage_space_low_limit,
  $storage_space_emergency_limit = $fhgfs::storage_space_emergency_limit,
  $version                       = $fhgfs::version,
  $log_dir                       = $fhgfs::log_dir,
  $log_level                     = 2,
  $user                          = $fhgfs::user,
  $group                         = $fhgfs::group,
  $package_ensure                = $fhgfs::package_ensure,
  $interfaces                    = ['eth0'],
  $interfaces_file               = '/etc/fhgfs/mgmtd.interfaces',
  ) inherits fhgfs {

  require fhgfs::install
  validate_array($interfaces)

  package { 'fhgfs-mgmtd':
    ensure  => $package_ensure,
  }

  # mgmgtd main directory
  file { $directory:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    recurse => true,
  }

  # make sure log directory exists
  ensure_resource('file', $log_dir, {
    'ensure' => directory,
    owner   => $user,
    group   => $group,
    recurse => true,
  })

  file { $interfaces_file:
    ensure => present,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    content => template('fhgfs/interfaces.erb'),
  }

  file { '/etc/fhgfs/fhgfs-mgmtd.conf':
    ensure  => present,
    owner   => $user,
    group   => $group,
    content => template('fhgfs/fhgfs-mgmtd.conf.erb'),
    require => [
      Package['fhgfs-mgmtd'],
      File[$interfaces_file],
    ],
  }

  service { 'fhgfs-mgmtd':
    ensure     => running,
    enable     => $enable,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package['fhgfs-mgmtd'],
      File[$interfaces_file],
    ],
    subscribe  => [
      File['/etc/fhgfs/fhgfs-mgmtd.conf'],
      File[$interfaces_file],
    ],
  }
}
