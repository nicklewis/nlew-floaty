# floaty

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with floaty](#setup)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module provides Puppet tasks and functions that use [vmfloaty](https://github.com/briancain/vmfloaty) to interact with [Puppet's vmpooler application](https://github.com/puppetlabs/vmpooler).

## Setup

Currently, this module requires that the `vmfloaty` gem is installed on the target node and that any necessary configuration is present in `~/.vmfloaty.yml`:

```yaml
url: https://vmpooler.example.com
token: '<vmpooler_api_token>'
```

## Usage

The simplest way to test out the module is to run it against `localhost` with [Bolt](https://github.com/puppetlabs/bolt):

```sh
$ bolt task run floaty::get platform=centos-7-x86_64 count=2 --nodes localhost
Started on localhost...
Finished on localhost:
  {
    "nodes": [
      "t8vhnjwomf59htp.example.com",
      "ft0jdxrgv899r0r.example.com"
    ]
  }
Successful on 1 node: localhost
Ran on 1 node in 0.52 seconds
```

## Reference

### Tasks

#### `floaty::get`

This task retrieve a set of nodes from vmpooler.

##### Parameters

`platform` : Which VM pool to retrieve nodes from (ie. `centos-7-x86_64`)  
`count` : How many nodes to retrieve (defaults to 1 if not specified)

##### Output

On success, the result will contain a `nodes` key, which is an array of the retrieved nodes. On failure, the result will contain an `_error` key describing the problem.

### Functions

#### `floaty::get(platform, count)`

This function retrieves a node or list of nodes from vmpooler by running `floaty` *locally*.

##### Parameters

`platform` : Which VM pool to retrieve nodes from (ie. `centos-7-x86_64`)  
`count` : How many nodes to retrieve (defaults to 1 if not specified)

##### Value

If one node was requested, the value is the name of node retrieved. If multiple nodes were requested, the value is an array of retrieved node names.

## Limitations

This module is currently only intended to solve a very specific use case, so it's probably quite fragile in cases where floaty itself isn't set up properly.

Currently, the `floaty::get` task only supports retrieving nodes from one pool at a time.

Use with caution.

## Development

Pull requests welcome!
