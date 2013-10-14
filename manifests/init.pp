# == Class: fhgfs
#
# Full description of class fhgfs here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { fhgfs:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Tomas Barton <barton.tomas@gmail.com>
#
# === Copyright
#
# Copyright 2013 Tomas Barton, unless otherwise noted.
#
class fhgfs {
  $manage_repo                   = true
  $mgmtd_host                    = 'localhost'
  $meta_directory                = '/meta'
  $storage_directory             = '/storage'
  $client_auto_remove_mins       = 0
  $meta_space_low_limit          = '5G'
  $meta_space_emergency_limit    = '3G'
  $storage_space_low_limit       = '100G'
  $storage_space_emergency_limit = '10G'
  $version                       = '2012.10.r8.debian7'
  $major_version                 = 'fhgfs_2012.10'
  $package_source                = 'fhgfs'
  $package_ensure                = 'present'
  $log_dir                       = '/var/log/fhgfs'
  $user                          = 'fhgfs'
  $group                         = 'fhgfs'
}

