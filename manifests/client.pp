# Class: fhgfs::client
#
# This module manages FhGFS client
#
class fhgfs::client (
  $user            = $fhgfs::user,
  $group           = $fhgfs::group,
  $package_ensure  = $fhgfs::package_ensure,
  $kernel_ensure   = present,
  $interfaces      = ['eth0'],
  $interfaces_file = '/etc/fhgfs/client.interfaces',
  $log_level       = 3,
  $mgmtd_host      = $fhgfs::mgmtd_host,
  $mgmtd_tcp_port  = 8008,
  $mgmtd_udp_port  = 8008,
) inherits fhgfs {

  require fhgfs::install
  validate_array($interfaces)

  anchor { 'fhgfs::kernel_dev' : }

  case $::osfamily {
    Debian: {
      ensure_resource('package', 'kernel-package', {
          'ensure' => $kernel_ensure,
          'before' => Anchor['fhgfs::kernel_dev']
        }
      )
      # we need current linux headers for building client module
      ensure_resource('package', 'linux-headers-generic', {
          'ensure' => 'present',
          'before' => Anchor['fhgfs::kernel_dev']
        }
      )
    }
    RedHat: {
      ensure_resource('package', 'kernel-devel', {
          'ensure' => $kernel_ensure,
          'before' => Anchor['fhgfs::kernel_dev']
        }
      )
    }
    default: {
      fail("OS Family '${::osfamily}' is not supported yet")
    }
  }

  file { $interfaces_file:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    content => template('fhgfs/interfaces.erb'),
  }

  file { '/etc/fhgfs/fhgfs-client.conf':
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => [
      Package['fhgfs-utils'],
      File[$interfaces_file],
    ],
    content => template('fhgfs/fhgfs-client.conf.erb'),
  }


  package { 'fhgfs-helperd':
    ensure => $package_ensure,
  }

  package { 'fhgfs-client':
    ensure  => $package_ensure,
    require => Anchor['fhgfs::kernel_dev'],
  }

  service { 'fhgfs-helperd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['fhgfs-helperd'],
  }

  file { '/etc/fhgfs/fhgfs-mounts.conf':
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => Package['fhgfs-client'],
  }

  service { 'fhgfs-client':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package['fhgfs-client'],
      Service['fhgfs-helperd'],
      File['/etc/fhgfs/fhgfs-mounts.conf'],
      File[$interfaces_file],
    ],
    subscribe  => [
      File['/etc/fhgfs/fhgfs-mounts.conf'],
      File[$interfaces_file],
    ],
  }
}
