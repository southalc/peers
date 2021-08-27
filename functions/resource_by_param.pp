# @summary Return an array of nodes by certname that have a resource matching the given
#   class, parameter, parameter value, and environment.
#
# @param class The class name associated with the resource.
# 
# @param parameter The parameter name associated with the resource.
# 
# @param value The value of the given parameter associated with the resource.
# 
# @param environment The environment to search for matching resources.
# 
# @example Get an array of nodes with the 'elasticsearch' class assigned that have the value
#   of 'cluster-01' assigned as the class parameter 'config.cluster.name':
#
#   $elk_servers = peers::resource_by_param('elasticsearch', 'config.cluster.name', 'cluster-01')
#
function peers::resource_by_param(
  String $class,
  String $parameter,
  String $value,
  String $environment = 'production',
  ) >> Array {

  $query = [
    'from', 'resources', [
      'and',
      ['=', 'type', 'Class'],
      ['=', 'environment', $environment],
      ['=', 'title', capitalize($class)],
      ['=', "parameters.${parameter}", $value]
    ]
  ]
  sort(puppetdb_query($query).map |$node| { $node['certname'] })
}
