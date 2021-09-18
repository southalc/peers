# @summary Return an array of nodes by certname that have a resource matching the given
#   class, trusted extension value, and environment.
#
# @param class The class name associated with the resource.
# 
# @param trusted_fact The name of the trusted fact extension to match.
# 
# @param value The value of the trusted fact extension to match.
# 
# @param env An optional environment to search for matching resources. Defaults to the node environment.
# 
# @return [Array] certnames that match function parameters
#
# @example Get an array of nodes with the 'elasticsearch' class assigned that have the value
#   of 'cluster-01' assigned as the trusted fact extension 'pp_cluster':
#
#   $elk_servers = peers::resource_by_tx('elasticsearch', 'pp_cluster', 'cluster-01')
#
function peers::resource_by_tx(
  String $class,
  String $trusted_fact,
  String $value,
  String $env = $server_facts['environment'],
  ) >> Array {

  $query = [
    'from', 'facts', [
      'and',
      ['=', 'name', 'trusted'], [
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
    if $trusted_fact in $node['value']['extensions'] and $node['value']['extensions'][$trusted_fact] == $value {
      $mem +  $node['certname']
    } else {
      $mem
    }
  }
  sort(unique($members))
}
