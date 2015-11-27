rabbitmq_host = node['formatron_sensu']['rabbitmq']['host']
rabbitmq_vhost = node['formatron_sensu']['rabbitmq']['vhost']
rabbitmq_user = node['formatron_sensu']['rabbitmq']['user']
rabbitmq_password = node['formatron_sensu']['rabbitmq']['password']
redis_host = node['formatron_sensu']['redis']['host']
api_host = node['formatron_sensu']['api']['host']
api_port = node['formatron_sensu']['api']['port']
graphite_host = node['formatron_sensu']['graphite']['host']
graphite_carbon_port = node['formatron_sensu']['graphite']['carbon_port']
wizard_van_commit = node['formatron_sensu']['wizard_van']['commit']
wizard_van_tarball_checksum = node['formatron_sensu']['wizard_van']['checksum']

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

cache = Chef::Config['file_cache_path']
wizard_van_tarball = File.join cache, 'wizard-van.tar.gz'
wizard_van_tarball_url = "https://codeload.github.com/opower/sensu-metrics-relay/legacy.tar.gz/#{wizard_van_commit}"

remote_file wizard_van_tarball do
  source wizard_van_tarball_url
  checksum wizard_van_tarball_checksum
  notifies :run, 'bash[install_wizard_van]', :immediately
end

bash 'install_wizard_van' do
  code <<-EOH.gsub(/^ {4}/, '')
    DIR=`mktemp -d`
    tar zxf #{wizard_van_tarball} -C $DIR --strip-components=1
    cp -R $DIR/lib/sensu/extensions/* /etc/sensu/extensions
  EOH
  action :nothing
  notifies :restart, 'service[sensu-server]', :delayed
  notifies :restart, 'service[sensu-api]', :delayed
end

template '/etc/sensu/conf.d/relay.json' do
  variables(
    host: graphite_host,
    port: graphite_carbon_port
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
  end
  notifies :restart, 'service[sensu-server]', :delayed
  notifies :restart, 'service[sensu-api]', :delayed
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
