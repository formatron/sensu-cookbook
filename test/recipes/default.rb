rabbitmq_host = 'localhost'
rabbitmq_vhost = '/test'
rabbitmq_user = 'test'
rabbitmq_password = 'password'
redis_host = 'localhost'

include_recipe 'formatron_erlang::default'

include_recipe 'formatron_rabbitmq::default'
formatron_rabbitmq_vhost rabbitmq_vhost
formatron_rabbitmq_user rabbitmq_user do
  password rabbitmq_password
end
formatron_rabbitmq_permissions rabbitmq_user do
  vhost rabbitmq_vhost
  conf '.*'
  write '.*'
  read '.*'
end

include_recipe 'formatron_redis::default'

node.override['formatron_sensu']['rabbitmq']['host'] = rabbitmq_host
node.override['formatron_sensu']['rabbitmq']['vhost'] = rabbitmq_vhost
node.override['formatron_sensu']['rabbitmq']['user'] = rabbitmq_user
node.override['formatron_sensu']['rabbitmq']['password'] = rabbitmq_password
node.override['formatron_sensu']['redis']['host'] = redis_host
node.override['formatron_sensu']['client']['subscriptions'] = ['test']
node.override['formatron_sensu']['api']['host'] = 'localhost'
node.override['formatron_sensu']['api']['port'] = 4567

include_recipe 'formatron_sensu::default'
include_recipe 'formatron_sensu::server'
include_recipe 'formatron_sensu::client'

formatron_sensu_check 'memory' do
  type 'metric'
  output_type 'graphite'
  auto_tag_host true
  command '/etc/sensu/plugins/check-memory.sh -w 128 -c 64'
  interval 10
  subscribers [
    'test'
  ]
  handlers [
    'relay'
  ]
  notifies :restart, 'service[sensu-server]', :delayed
end

formatron_sensu_handler 'default' do
  command 'cat'
  type 'pipe'
  notifies :restart, 'service[sensu-server]', :delayed
end

cookbook_file '/etc/sensu/plugins/check-memory.sh' do
  owner 'sensu'
  group 'sensu'
  mode '0755'
end
