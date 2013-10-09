# Class: fhgfs::repo
#
# This module manages fhgfs repository installation
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class fhgfs::repo(
  $manage_repo    = true,
  $package_source = 'fhgfs',
  $version        = 'fhgfs_2012.10'
) {
  anchor { 'fhgfs::repo::begin': }
  anchor { 'fhgfs::repo::end': }

  case $::osfamily {
    'redhat': {
      class { 'fhgfs::repo::redhat':
        manage_repo    => $manage_repo,
        require        => Anchor['fhgfs::repo::begin'],
        before         => Anchor['fhgfs::repo::end'],
      }
    }
    'debian': {
      class { 'fhgfs::repo::debian':
        require        => Anchor['fhgfs::repo::begin'],
        before         => Anchor['fhgfs::repo::end'],
      }
    }
    default: {
        fail("Module ${module_name} is not supported on ${::operatingsystem}")
      }
    }
  }
}
