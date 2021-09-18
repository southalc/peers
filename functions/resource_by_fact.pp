# @summary Return an array of nodes by certname that have a resource matching the given
#   class, fact value, and environment.
#
# @param class The class name associated with the resource.
# 
# @param fact The fact name from the node with the resource.
# 
# @param value The value of the given fact for the node.
# 
# @param env An optional environment to search for matching resources. Defaults to the node environment.
#
# @return [Array] certnames that match function parameters
# 
# @example Get an array of nodes with the 'elasticsearch' class assigned that have the value
#   of 'cluster-01' assigned as the fact named 'cluster':
#
#   $elk_servers = peers::resource_by_fact('elasticsearch', 'cluster', 'cluster-01')
#
function peers::resource_by_fact(
  String $class,
  String $fact,
  String $value,
  String $env = $server_facts['environment'],
  ) >> Array {

  $query = [
    'from', 'facts', [
      'and',
      ['=', 'name', $fact], [
        'in', 'certname', [
          'extract', 'certname', [
            'select_resources', [
              'and',
              ['=', 'type', 'Class'],
              ['=', 'environment', $env],
              ['=', 'title', capitalize($class)],
            ]
          ]
        ]
      ]
    ]
  ]

  # Execute the query and reduce results to an array of nodes that match
  $members = puppetdb_query($query).reduce([]) |$mem, $node| {
    if 'value' in $node and $node['value'] == $value {
      $mem + $node['certname']
    } else {
      $mem
    }
  }
  sort(unique($members))
}
