# @summary Return a hash of certnames mapped to fact values when the node has a resource matching
# the given class, parameter value, fact name, and environment.
#
# @param class The class name associated with the resource.
# 
# @param parameter The parameter name associated with the resource.
# 
# @param value The value of the given parameter associated with the resource.
#
# @param fact The name of some fact where the value will be paired with the certname in the returned hash.
# 
# @param env An optional environment to search for matching resources. Defaults to the node environment.
# 
# @return [Hash] Hash keys are certnames with values set to value of the given fact for the node.
#
# @example Get a hash where the keys are nodes with the 'elasticsearch' class assigned that have the value
#   of 'cluster-01' assigned as the class parameter 'config.cluster.name', and the hash values are from the
#   custom fact 'node_cert_serial':
#   
#   $elk_servers = peers::resource_by_param('elasticsearch', 'config.cluster.name', 'cluster-01', 'node_cert_serial')
#
function peers::resource_by_param_w_fact(
  String $class,
  String $parameter,
  String $value,
  String $fact,
  String $env= $server_facts['environment'],
  ) >> Hash {

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
              ['=', "parameters.${parameter}", $value]
            ]
          ]
        ]
      ]
    ]
  ]
  $result = puppetdb_query($query)
  if $result.empty {
    {}
  } else {
    $result.reduce({}) |$mem, $x| {
      merge($mem, { $x['certname'] => $x['value'] })
    }
  }
}


