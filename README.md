# Puppet FhGFS

[![Build Status](https://travis-ci.org/deric/puppet-fhgfs.png?branch=travis)](https://travis-ci.org/deric/puppet-fhgfs)

This is the puppet-fhgfs module for managing the Fraunhofer Parallel File System (FhGFS)

## Usage

You need one mgmtd server:

```puppet
    class { 'fhgfs::mgmtd': }
```

And probably many storage and meta servers:
```puppet
    class { 'fhgfs::meta':
      mgmtd_host => 192.168.1.1,
    }
    class { 'fhgfs::storage':
      mgmtd_host => 192.168.1.1,
    }
```

defining a mount
```puppet
  fhgfs::mount{ 'mnt-share':
    cfg => '/etc/fhgfs/fhgfs-client.conf',
    mnt   => '/mnt/share',
    user  => 'fhgfs',
    group => 'fhgfs',
  }
```

### Interfaces

For meta and storage nodes you can specify interfaces for commutication. The passed argument must be an array.

```puppet
    class { 'fhgfs::meta':
      mgmtd_host => 192.168.1.1,
      interfaces => ['eth0', 'ib0'],
    }
    class { 'fhgfs::storage':
      mgmtd_host => 192.168.1.1,
      interfaces => ['eth0', 'ib0']
    }
```

## Hiera support

All configuration could be specified in Hiera config files. Some settings
are shared between all components, like:

```
fhgfs::version: '2012.10.r9.debian7'
```

for module specific setting use correct namespace, e.g.:
```
fhgfs::meta::interfaces:
  - 'eth0'
```


## License

Apache License, Version 2.0

