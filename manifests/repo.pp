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
  $manage_repo    = $fhgfs::manage_repo,
  $package_source = $fhgfs::package_source,
  $package_ensure = $fhgfs::package_ensure,
) inherits fhgfs {
  anchor { 'fhgfs::repo::begin': }
  anchor { 'fhgfs::repo::end': }

  case $::osfamily {
    Debian: {
      class { 'fhgfs::repo::debian':
        package_ensure => $package_ensure,
        require        => Anchor['fhgfs::repo::begin'],
        before         => Anchor['fhgfs::repo::end'],
      }
    }
    RedHat: {
      class { 'fhgfs::repo::redhat':
        package_ensure => $package_ensure,
        require        => Anchor['fhgfs::repo::begin'],
        before         => Anchor['fhgfs::repo::end'],
      }
    }
    default: {
      fail("Module '${module_name}' is not supported on OS: '${::operatingsystem}', family: '${::osfamily}'")
    }
  }
}
