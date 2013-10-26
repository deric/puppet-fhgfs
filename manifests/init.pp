# == Class: fhgfs
#
# [*version*] package version e.g. '2012.10.r8.debian7'
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
  $manage_repo                   = hiera('fhgfs::manage_repo', true)
  $mgmtd_host                    = hiera('fhgfs::mgmtd_host', 'localhost')
  $meta_directory                = hiera('fhgfs::meta_directory', '/meta')
  $storage_directory             = hiera('fhgfs::storage_directory', '/storage')
  $client_auto_remove_mins       = hiera('fhgfs::client_auto_remove_mins', 0)
  $meta_space_low_limit          = hiera('fhgfs::meta_space_low_limit', '5G')
  $meta_space_emergency_limit    = hiera('fhgfs::meta_space_emergency_limit', '3G')
  $storage_space_low_limit       = hiera('fhgfs::storage_space_low_limit', '100G')
  $storage_space_emergency_limit = hiera('fhgfs::storage_space_emergency_limit', '10G')
  $package_source                = hiera('fhgfs::package_source', 'fhgfs')
  $version                       = hiera('fhgfs::version', undef)
  $log_dir                       = hiera('fhgfs::log_dir', '/var/log/fhgfs')
  $user                          = hiera('fhgfs::user', 'fhgfs')
  $group                         = hiera('fhgfs::group','fhgfs')
  $major_version                 = hiera('fhgfs::major_version','fhgfs_2012.10')
  $admon_db_file                 = hiera('fhgfs::admon_db_file','/var/lib/fhgfs/fhgfs-admon.db')

  if ($version == undef){
    $package_ensure = 'present'
  }else{
    $package_ensure = $version
  }
}

