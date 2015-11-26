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

default['formatron_sensu']['wizard_van']['commit'] = '541c446a1426659623074c2e53e75e348a128916'
default['formatron_sensu']['wizard_van']['checksum'] = '7e7b55278f0e54c5fbdccdd2dbf240ca7b5b81a35060b0361e2098bb3caa34a5'

default['formatron_sensu']['graphite']['host'] = 'localhost'
default['formatron_sensu']['graphite']['port'] = 8080
