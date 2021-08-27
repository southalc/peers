# @summary A short summary of the purpose of this class
#
class peers {
  $elk_param = peers::resource_by_param('elasticsearch', 'config.cluster.name', 'elk-cluster-01')
  notify { 'elk_param': message => $elk_param.join(', '), }

  $elk_tag = peers::resource_by_tag('elasticsearch', 'profile::elk')
  notify { 'elk_tag': message => $elk_tag.join(', '), }
}
