# Define: fhgfs::mount
#
# This module manages FhGFS mounts
#
define fhgfs::mount (
  $cfg,
  $mnt,
  $user   = $fhgfs::user,
  $group  = $fhgfs::group,

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
    path    => '/etc/fhgfs/fhgfs-mounts.conf',
    require => File[$mnt],
  }
}
