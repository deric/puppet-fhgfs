# Define: fhgfs::client
#
# This module manages FhGFS client
#
define fhgfs::mount ($cfg, $mnt, $subdir = '') {
  include fhgfs::client

  file { $mnt:
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
  }
  file { "/etc/fhgfs/${cfg}":
    require => Package['fhgfs-client'],
    source  => "puppet:///files/fhgfs/${subdir}/${cfg}",
  }
}
