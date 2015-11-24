default['formatron_sensu']['rabbitmq']['host'] = 'localhost'
default['formatron_sensu']['rabbitmq']['vhost'] = '/sensu'
default['formatron_sensu']['rabbitmq']['user'] = 'sensu'
default['formatron_sensu']['rabbitmq']['password'] = 'secret'

default['formatron_sensu']['redis']['host'] = 'localhost'

default['formatron_sensu']['api']['host'] = 'localhost'
default['formatron_sensu']['api']['port'] = 4567

default['formatron_sensu']['client']['name'] = node['fqdn']
default['formatron_sensu']['client']['address'] = node['fqdn']
default['formatron_sensu']['client']['subscriptions'] = []
