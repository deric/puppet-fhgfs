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

) inherits fhgfs::params {


  class { 'fhgfs::repo'
    $manage_repo    = true,
    $package_source = 'fhgfs',
    $version        = 'fhgfs_2012.10'
  }

  case $major_version {
    default: {
      require yum::repo::fhgfs
    }
    '2011': {
      require yum::repo::fhgfs
    }
    '2012': {
      require yum::repo::fhgfs2012
    }
  }

  package { 'fhgfs-utils':
    ensure => $version,
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
