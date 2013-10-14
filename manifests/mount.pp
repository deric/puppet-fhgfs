# Define: fhgfs::client
#
# This module manages FhGFS client
#
define fhgfs::mount (
  $cfg,
  $mnt,
  $subdir = ''
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

  file { "/etc/fhgfs/${cfg}":
    require => Package['fhgfs-client'],
    source  => "puppet:///files/fhgfs/${subdir}/${cfg}",
  }
}
