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
default['formatron_sensu']['graphite']['carbon_port'] = 2003

default['formatron_sensu']['elasticsearch_handler']['commit'] = 'd71767124cf3932423fe56907a7cf3a17a13a0c1'
default['formatron_sensu']['elasticsearch_handler']['checksum'] = 'c7adf7d46a9cd7d1aa8fa3aed75a559deef211f508297ff2cd7042b5530a247e'

default['formatron_sensu']['elasticsearch']['host'] = 'localhost'
default['formatron_sensu']['elasticsearch']['port'] = 9200
default['formatron_sensu']['elasticsearch']['index'] = 'sensu-metrics'

# checks should be a hash of checks to configure on the server
#
# eg:
#
# {
#   my_check: {
#     gem: 'my_gem',
#     attributes: {
#       command: 'my_gem.rb'
#       ...
#     }
#   },
#   ...
# }
#
default['formatron_sensu']['checks'] = {}

# gems should be a hash of gems to install on clients
#
# eg: 
#
# {
#   my_gem: {
#     gem: 'my_gem',
#     version: '0.0.0'
#   },
#   ...
# }
default['formatron_sensu']['gems'] = {}
