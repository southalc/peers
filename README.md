# peers

## Table of Contents

1. [Description](#description)
1. [Setup](#setup)
1. [Usage](#usage)
1. [Limitations](#limitations)
1. [Development](#development)

## Description

This module includes functions to obtain an array of nodes with puppet resources
that match specific criteria.  This is useful for things like getting a dynamic
list of nodes that are cluster members. The module does not use exported resources,
although puppetdb is required.

## Setup

Deploying the module to an environment should be all that is necessary to use the
included functions.  The module does not manage any resources.

## Usage

The following example uses the 'peers::resource_by_param' function in a manifest
to get an array of nodes that have the 'elasticsearch' class assigned with the
'config.cluster.name' parameter set to 'cluster-1'.  Based on the returned array
you can do things like check if the current node is already a member, join the
cluster, adjust the value for quorum, and update seed hosts.
```
$elk_servers = peers::resource_by_param('elasticsearch', 'config.cluster.name', 'cluster-1')
```

The functions default to the node's environment, but this can be overridden
by passing another parameter to the function. To repeat the last Elasticsearch
query, but in the "test" environment:
```
$elk_servers = peers::resource_by_param('elasticsearch', 'config.cluster.name', 'cluster-1', 'test')
```

The other module functions enable searching for nodes based on different criteria.  See
the module reference for details, but here's another example to get nodes with the
'elasticsearch' module assigned, this time matching nodes based on the trusted
fact extension 'pp_cluster' set to the value of 'cluster-01':
```
$elk_servers = peers::resource_by_tx('elasticsearch', 'pp_cluster', 'cluster-01')
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

I'd appreciate any feedback.  To contribute to development, fork the source and submit a pull request.

