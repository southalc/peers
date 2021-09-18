# @summary Return an array of nodes by certname that have a resource matching the given
#   class, tag, and environment.
#
# @param class The class name associated with the resource.
# 
# @param tag The value of a tag associated with the resource.
# 
# @param env An optional environment to search for matching resources. Defaults to the node environment.
#
# @return [Array] certnames that match function parameters
# 
function peers::resource_by_tag(
  String $class,
  String $tag,
  String $env = $server_facts['environment'],
  ) >> Array {

  $query = [
    'from', 'resources', [
      'and',
      ['=', 'type', 'Class'],
      ['=', 'environment', $env],
      ['=', 'title', capitalize($class)],
      ['=', 'tag', $tag]
    ]
  ]
  sort(puppetdb_query($query).map |$node| { $node['certname'] })
}
