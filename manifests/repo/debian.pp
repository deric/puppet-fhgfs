# Class: fhgfs::repo::debian

class fhgfs::repo::debian (
  $manage_repo    = true,
  $package_source = 'fhgfs',
  $version        = 'fhgfs_2012.10'
) {


 $distro = downcase($::operatingsystem)

  case $::operatingsystem {
    Debian: {
      case $::lsbdistcodename {
        'wheezy': {
          $folder = 'deb7'
        }
        'squeeze': {
          $folder = 'deb6'
        }
      }
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
          repos      => 'fhgfs',
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