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
}
