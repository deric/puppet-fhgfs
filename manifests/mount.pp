# Define: fhgfs::mount
#
# This module manages FhGFS mounts
#
define fhgfs::mount (
  $cfg,
  $mnt,
  $user       = $fhgfs::user,
  $group      = $fhgfs::group,
  $mounts_cfg = '/etc/fhgfs/fhgfs-mounts.conf',
) {

  include fhgfs::client

  file { $mnt:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
  }

  file_line { 'mnt_config':
    line    => "${mnt} ${cfg}",
    path    => $mounts_cfg,
    require => [ File[$mounts_cfg], File[$mnt] ],
  }
}
