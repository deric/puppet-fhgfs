# Puppet FhGFS

[![Build Status](https://travis-ci.org/deric/puppet-fhgfs.png?branch=travis)](https://travis-ci.org/deric/puppet-fhgfs)

This is the puppet-fhgfs module for managing the Fraunhofer Parallel File System (FhGFS)

## Usage

You need one mgmtd server:

```
    class { 'fhgfs::mgmtd': }
```

And probably many storage and meta servers:
```
    class { 'fhgfs::meta':
      mgmtd_host => 192.168.1.1,
    }
    class { 'fhgfs::storage':
      mgmtd_host => 192.168.1.1,
    }
```

defining mount
```
  fhgfs::mount{ 'mnt-share':
    cfg => '/etc/fhgfs/fhgfs-client.conf',
    mnt   => '/mnt/share',
    user  => 'fhgfs',
    group => 'fhgfs',
  }
```

## License

Apache License, Version 2.0

