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

# get the list of subscribed checks
checks = node['formatron_sensu']['checks']
subscribed_checks = checks.select do |name, check|
  !((check['attributes']['subscribers'] & client_subscriptions).empty?)
end

# install required gems
checks_with_gems = subscribed_checks.values.select do |check|
  !(check['gem'].nil?)
end
required_gems = checks_with_gems.collect { |check| check['gem'] }
required_gems.uniq!
gems = node['formatron_sensu']['gems']
required_gems.each do |gem|
  params = gems[gem]
  formatron_sensu_gem gem do
    gem params['gem'] || gem
    version params['version']
  end
end

# create standalone checks
subscribed_checks.each do |name, check|
  if check['attributes']['standalone'].eql? true
    formatron_sensu_check name do
      gem check['gem']
      attributes check['attributes']
      notifies :restart, 'service[sensu-client]', :delayed
    end
  end
end

service 'sensu-client' do
  supports status: true, restart: true, reload: false
  action [ :enable, :start ]
  subscribes :restart, 'template[/etc/sensu/conf.d/rabbitmq.json]', :delayed
end
