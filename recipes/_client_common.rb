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

# install gems required for the client subscriptions
checks = node['formatron_sensu']['checks'].values
checks.select! do |check|
  log 'subscribers' do
    message check['subscribers']
  end
  log 'subscriptions' do
    message client_subscriptions
  end
  !(check['gem'].nil?) &&
  !((check['subscribers'] & client_subscriptions).empty?)
end
required_gems = checks.collect { |check| check['gem'] }
required_gems.uniq!
gems = node['formatron_sensu']['gems']
required_gems.each do |gem|
  params = gems[gem]
  formatron_sensu_gem gem do
    gem params['gem'] || gem
    version params['version']
  end
end
