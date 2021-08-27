# peers

## Table of Contents

1. [Description](#description)
1. [Setup](#setup)
1. [Usage](#usage)
1. [Limitations](#limitations)
1. [Development](#development)

## Description

Clustered applications often require the cluster members to be defined in the
configuration.  This module offers a simplified way to obtain this data in your
manifests by providing functions to locate nodes with specific resources.  The
functions identify nodes by the puppet certname, but since this is typically the
FQDN of the node it should be sufficient for most use cases.

## Setup

Deploying the module to an environment should be all that is necessary to use the
included functions.  The module itself does not manage any resources.

The module requires puppetdb to be installed as it relys on the 'puppetdb_query' function.

### Beginning with peers

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most basic
use of the module.

## Usage

The following example uses the 'peers::resource_by_param' function in a manifest
to get an array of nodes that have the 'elasticsearch' class assigned with the
'config.cluster.name' parameter set to 'elk-cluster-01'.  Based on the returned
array you can do things like check if the current node is already a member, join
the cluster, adjust the value for quorum, and update seed hosts.
```
$elk_servers = peers::resource_by_param('elasticsearch', 'config.cluster.name', 'cluster-1')
```

The functions default to the 'production' environment, but this can be passed to
as a parameter.  To repeat the above Elasticsearch query, but in the "test"
environment:
```
$elk_servers = peers::resource_by_param('elasticsearch', 'config.cluster.name', 'cluster-1', 'test')
```

Besides direct configuration of the Elasticsearch cluster, the array of cluster
nodes could be useful to setup a kibana resource:
```
$elk_servers = peers::resource_by_param('elasticsearch', 'config.cluster.name', 'cluster-1')

class { 'kibana':
  config  => {
    'server.host'         => fact('networking.ip'),
    'elasticsearch.hosts' => $elk_servers.map |$node| { "http://${node}:9200" },
  },
}
```

## Limitations

The module uses a fairly basic puppetdb query and should work with all supported
Puppet distributions where puppetdb is included.

## Development

I'd appreciate any feedback.  To contribute to development, fork the source and
submit a pull request.

