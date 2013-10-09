# Class: fhgfs::param
#
# This module manages FhGFS paramaters
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
class fhgfs::params {
  $manage_repo        = true
  $mgmtd_host         = 'localhost',
  $meta_directory     = '/meta',
  $storage_directory  = '/storage',
  $mgmtd_directory    = '/mgmtd',
  $client_auto_remove_mins       = 0,
  $meta_space_low_limit          = '5G',
  $meta_space_emergency_limit    = '3G',
  $storage_space_low_limit       = '100G',
  $storage_space_emergency_limit = '10G',
  $version = '2011.04.r21-el6',
  $major_version = '2011',
}
