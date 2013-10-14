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
  $user                          = $fhgfs::user,
  $group                         = $fhgfs::group,
  ) inherits fhgfs {

  require fhgfs::install

  package { 'fhgfs-mgmtd':
    ensure  => $version,
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

  file { '/etc/fhgfs/fhgfs-mgmtd.conf':
    require => Package['fhgfs-mgmtd'],
    owner   => $user,
    group   => $group,
    content => template('fhgfs/fhgfs-mgmtd.conf.erb'),
  }

  service { 'fhgfs-mgmtd':
    ensure     => running,
    enable     => $enable,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['fhgfs-mgmtd'],
    subscribe  => File['/etc/fhgfs/fhgfs-mgmtd.conf'];
  }
}
