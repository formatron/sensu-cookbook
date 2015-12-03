redis_host = node['formatron_sensu']['redis']['host']
api_host = node['formatron_sensu']['api']['host']
api_port = node['formatron_sensu']['api']['port']

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
checks.each do |name, check|
  unless check['attributes']['standalone'].eql? true
    formatron_sensu_check name do
      gem check['gem']
      attributes check['attributes']
      notifies :restart, 'service[sensu-server]', :delayed
      notifies :restart, 'service[sensu-api]', :delayed
    end
  end
end

service 'sensu-server' do
  supports status: true, restart: true, reload: false
  action [ :enable, :start ]
  subscribes :restart, 'template[/etc/sensu/conf.d/rabbitmq.json]', :delayed
end

service 'sensu-api' do
  supports status: true, restart: true, reload: false
  action [ :enable, :start ]
  subscribes :restart, 'template[/etc/sensu/conf.d/rabbitmq.json]', :delayed
end
