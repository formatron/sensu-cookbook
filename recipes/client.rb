rabbitmq_host = node['formatron_sensu']['rabbitmq']['host']
rabbitmq_vhost = node['formatron_sensu']['rabbitmq']['vhost']
rabbitmq_user = node['formatron_sensu']['rabbitmq']['user']
rabbitmq_password = node['formatron_sensu']['rabbitmq']['password']

include_recipe 'formatron_sensu::_install'

template '/etc/sensu/conf.d/rabbitmq.json' do
  owner 'sensu'
  group 'sensu'
  variables(
    rabbitmq_host: rabbitmq_host,
    rabbitmq_vhost: rabbitmq_vhost,
    rabbitmq_user: rabbitmq_user,
    rabbitmq_password: rabbitmq_password,
  )
  notifies :restart, 'service[sensu-client]', :delayed
end

include_recipe 'formatron_sensu::_client_common'
