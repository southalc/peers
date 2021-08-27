# @summary Return an array of nodes by certname that have a resource matching the given
#   class, tag, and environment.
#
# @param class The class name associated with the resource.
# 
# @param tag The value of a tag associated with the resource.
# 
# @param environment The environment of the matching resources.
# 
function peers::resource_by_tag(
  String $class,
  String $tag,
  String $environment = 'production',
  ) >> Array {

  $query = [
    'from', 'resources', [
      'and',
      ['=', 'type', 'Class'],
      ['=', 'environment', $environment],
      ['=', 'title', capitalize($class)],
      ['=', 'tag', $tag]
    ]
  ]
  sort(puppetdb_query($query).map |$node| { $node['certname'] })
}
