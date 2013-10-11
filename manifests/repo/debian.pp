# Class: fhgfs::repo::debian

class fhgfs::repo::debian (
  $manage_repo    = true,
  $package_source = $fhgfs::params::package_source,
  $version        = $fhgfs::params::version,
) {

# $distro = downcase($::operatingsystem)

  case $::operatingsystem {
    Debian: {
      case $::lsbdistcodename {
        'wheezy': {
          $folder = 'deb7'
        }
        'squeeze': {
          $folder = 'deb6'
        }
        default: {
          fail ("${::lsbdistcodename} is not supported yet")
        }
      }
    }
    Ubuntu: {
      case $::lsbdistcodename {
        'precise': {
          $folder = 'deb7'
        }
        default: {
          fail ("${::lsbdistcodename} is not supported yet")
        }
      }
    }
    default: {
      fail ("${$::operatingsystem} is not supported yet")
    }
  }

  package { $package_name:
    ensure  => $package_ensure,
    require => Anchor['fhgfs::apt_repo'],
  }

  anchor { 'fhgfs::apt_repo' : }

  include '::apt'

  if $manage_repo {
    case $package_source {
      'fhgfs': {
        apt::source { 'fhgfs':
          location   => "http://www.fhgfs.com/release/${version}/${folder}",
          repos      => 'non-free',
          key        => '64497785',
          key_source => 'http://www.fhgfs.com/release/latest-stable/gpg/DEB-GPG-KEY-fhgfs',
          notify     => Exec['apt_get_update_for_fhgfs'],
        }
      }
      default: {}
    }

    exec { 'apt_get_update_for_fhgfs':
      command     => '/usr/bin/apt-get update',
      timeout     => 240,
      returns     => [ 0, 100 ],
      refreshonly => true,
      before      => Anchor['fhgfs::apt_repo'],
    }
  }
}
