rabbitmq_host = node['formatron_sensu']['rabbitmq']['host']
rabbitmq_vhost = node['formatron_sensu']['rabbitmq']['vhost']
rabbitmq_user = node['formatron_sensu']['rabbitmq']['user']
rabbitmq_password = node['formatron_sensu']['rabbitmq']['password']

apt_repository 'sensu' do
  uri 'http://repositories.sensuapp.org/apt'
  distribution 'sensu'
  components ['main']
  key 'http://repositories.sensuapp.org/apt/pubkey.gpg'
end

package 'sensu'

execute 'chown -R sensu:sensu /etc/sensu'

# workaround so that sensu services don't try to start
# with a hostname that can't be resolved
def resolve_address(hostname)
  ::Resolv.getaddress hostname
rescue
  'localhost'
end
rabbitmq_host = resolve_address rabbitmq_host

template '/etc/sensu/conf.d/rabbitmq.json' do
  owner 'sensu'
  group 'sensu'
  variables(
    rabbitmq_host: rabbitmq_host,
    rabbitmq_vhost: rabbitmq_vhost,
    rabbitmq_user: rabbitmq_user,
    rabbitmq_password: rabbitmq_password
  )
end

gem_package 'sensu-plugin' do
  gem_binary Sensu::BundleHelper::GEM_BINARY
end
