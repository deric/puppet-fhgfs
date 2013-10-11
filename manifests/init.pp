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
class fhgfs (
  $manage_repo                   = $fhgfs::params::manage_repo,
  $mgmtd_host                    = $fhgfs::params::mgmtd_host,
  $meta_directory                = $fhgfs::params::meta_directory,
  $storage_directory             = $fhgfs::params::storage_directory,
  $mgmtd_directory               = $fhgfs::params::mgmtd_directory,
  $client_auto_remove_mins       = $fhgfs::params::client_auto_remove_mins,
  $meta_space_low_limit          = $fhgfs::params::meta_space_low_limit,
  $meta_space_emergency_limit    = $fhgfs::params::meta_space_emergency_limit,
  $storage_space_low_limit       = $fhgfs::params::storage_space_low_limit,
  $storage_space_emergency_limit = $fhgfs::params::storage_space_emergency_limit,
  $version                       = $fhgfs::params::version,
  $major_version                 = $fhgfs::params::major_version,
  $package_source                = $fhgfs::params::package_source,
) inherits fhgfs::params {

  class { 'fhgfs::repo':
    manage_repo    => $manage_repo,
    package_source => $package_source,
    version        => $version,
  }

  package { 'fhgfs-utils':
    ensure  => $version,
    require => Class['fhgfs::repo']
  }

  file { '/etc/fhgfs/fhgfs-client.conf':
    require => Package['fhgfs-utils'],
    content => template('fhgfs/fhgfs-client.conf.erb'),
  }

  # Allow the end user to establish relationships to the "main" class
  # and preserve the relationship to the implementation classes through
  # a transitive relationship to the composite class.
  anchor{ 'fhgfs::begin':
    before => Class['fhgfs::repo'],
    notify => Class['fhgfs::service'],
  }
  anchor { 'fhgfs::end':
    require => Class['fhgfs::service'],
  }

}
