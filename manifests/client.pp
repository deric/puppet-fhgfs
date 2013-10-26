# Class: fhgfs::client
#
# This module manages FhGFS client
#
class fhgfs::client (
  $user           = $fhgfs::user,
  $group          = $fhgfs::group,
  $package_ensure = $fhgfs::package_ensure,
  $kernel_ensure  = present,
) inherits fhgfs {

  require fhgfs::install

  anchor { 'fhgfs::kernel_dev' : }

  case $::osfamily {
    Debian: {
      package { 'kernel-package' :
        ensure => $kernel_ensure,
        before => Anchor['fhgfs::kernel_dev']
      }
    }
    RedHat: {
      package { 'kernel-devel' :
        ensure => $kernel_ensure,
        before => Anchor['fhgfs::kernel_dev']
      }
    }
    default: {
      fail("OS Family '${::osfamily}' is not supported yet")
    }
  }

  package { 'fhgfs-helperd':
    ensure   => $package_ensure,
  }
  package { 'fhgfs-client':
    ensure   => $package_ensure,
    require  => Anchor['fhgfs::kernel_dev'],
  }
  service { 'fhgfs-helperd':
    ensure   => running,
    enable   => true,
    hasstatus  => true,
    hasrestart => true,
    require  => Package['fhgfs-helperd'],
  }
  file { '/etc/fhgfs/fhgfs-mounts.conf':
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => Package['fhgfs-client'],
  }

  service { 'fhgfs-client':
    ensure   => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package['fhgfs-client'],
      Service['fhgfs-helperd'],
      File['/etc/fhgfs/fhgfs-mounts.conf']
    ],
  }
}
