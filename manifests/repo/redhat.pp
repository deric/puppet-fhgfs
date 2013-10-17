# Class: fhgfs::repo::debian

class fhgfs::repo::redhat (
  $manage_repo    = true,
  $package_source = $fhgfs::package_source,
  $package_ensure = $fhgfs::package_ensure,
  $major_version  = $fhgfs::major_version,
) {

  package { 'fhgfs-utils':
    ensure  => $package_ensure,
  }

}
