rabbitmq_host = node['formatron_sensu']['rabbitmq']['host']
rabbitmq_vhost = node['formatron_sensu']['rabbitmq']['vhost']
rabbitmq_user = node['formatron_sensu']['rabbitmq']['user']
rabbitmq_password = node['formatron_sensu']['rabbitmq']['password']
redis_host = node['formatron_sensu']['redis']['host']
api_host = node['formatron_sensu']['api']['host']
api_port = node['formatron_sensu']['api']['port']

include_recipe 'formatron_sensu::_install'

node.override['formatron_sensu']['is_server'] = true

template '/etc/sensu/conf.d/rabbitmq.json' do
  owner 'sensu'
  group 'sensu'
  variables(
    rabbitmq_host: rabbitmq_host,
    rabbitmq_vhost: rabbitmq_vhost,
    rabbitmq_user: rabbitmq_user,
    rabbitmq_password: rabbitmq_password
  )
  notifies :restart, 'service[sensu-server]', :delayed
  notifies :restart, 'service[sensu-api]', :delayed
  notifies :restart, 'service[sensu-client]', :delayed
end

template '/etc/sensu/conf.d/redis.json' do
  owner 'sensu'
  group 'sensu'
  variables(
    redis_host: redis_host
  )
  notifies :restart, 'service[sensu-server]', :delayed
  notifies :restart, 'service[sensu-api]', :delayed
end

include_recipe 'formatron_sensu::_wizardvan'
include_recipe 'formatron_sensu::_elasticsearch'

template '/etc/sensu/conf.d/api.json' do
  owner 'sensu'
  group 'sensu'
  variables(
    host: api_host,
    port: api_port
  )
  notifies :restart, 'service[sensu-server]', :delayed
  notifies :restart, 'service[sensu-api]', :delayed
end

# add checks configured in attributes
checks = node['formatron_sensu']['checks']
checks.each do |name, params|
  formatron_sensu_check name do
    gem params['gem']
    attributes params['attributes']
    notifies :restart, 'service[sensu-server]', :delayed
    notifies :restart, 'service[sensu-api]', :delayed
  end
end

service 'sensu-server' do
  supports status: true, restart: true, reload: false
  action [ :enable, :start ]
end

service 'sensu-api' do
  supports status: true, restart: true, reload: false
  action [ :enable, :start ]
end

include_recipe 'formatron_sensu::_client_common'
