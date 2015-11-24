client_name = node['formatron_sensu']['client']['name']
client_address = node['formatron_sensu']['client']['address']
client_subscriptions = node['formatron_sensu']['client']['subscriptions']

template '/etc/sensu/conf.d/client.json' do
  owner 'sensu'
  group 'sensu'
  variables(
    name: client_name,
    address: client_address,
    subscriptions: client_subscriptions
  )
  notifies :restart, 'service[sensu-client]', :delayed
end

service 'sensu-client' do
  supports status: true, restart: true, reload: false
  action [ :enable, :start ]
end
