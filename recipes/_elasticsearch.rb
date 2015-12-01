elasticsearch_host = node['formatron_sensu']['elasticsearch']['host']
elasticsearch_port = node['formatron_sensu']['elasticsearch']['port']
elasticsearch_index = node['formatron_sensu']['elasticsearch']['index']
elasticsearch_handler_commit = node['formatron_sensu']['elasticsearch_handler']['commit']
elasticsearch_handler_tarball_checksum = node['formatron_sensu']['elasticsearch_handler']['checksum']
cache = Chef::Config['file_cache_path']
elasticsearch_handler_tarball = File.join cache, 'elasticsearch_handler.tar.gz'
elasticsearch_handler_tarball_url = "https://codeload.github.com/hico-horiuchi/sensu-elasticsearch/legacy.tar.gz/#{elasticsearch_handler_commit}"

remote_file elasticsearch_handler_tarball do
  source elasticsearch_handler_tarball_url
  checksum elasticsearch_handler_tarball_checksum
  notifies :run, 'bash[install_elasticsearch_handler]', :immediately
end

bash 'install_elasticsearch_handler' do
  code <<-EOH.gsub(/^ {4}/, '')
    DIR=`mktemp -d`
    tar zxf #{elasticsearch_handler_tarball} -C $DIR --strip-components=1
    cp $DIR/elasticsearch_handler.rb /etc/sensu/handlers
    cp $DIR/elasticsearch_metrics.rb /etc/sensu/handlers
    rm -rf $DIR
  EOH
  action :nothing
  notifies :restart, 'service[sensu-server]', :delayed
  notifies :restart, 'service[sensu-api]', :delayed
end

template '/etc/sensu/conf.d/elasticsearch.json' do
  variables(
    host: elasticsearch_host,
    port: elasticsearch_port,
    index: elasticsearch_index
  )
  notifies :restart, 'service[sensu-server]', :delayed
  notifies :restart, 'service[sensu-api]', :delayed
end

formatron_sensu_handler 'elasticsearch_handler' do
  attributes(
    type: 'pipe',
    command: 'elasticsearch_handler.rb'
  )
  notifies :restart, 'service[sensu-server]', :delayed
  notifies :restart, 'service[sensu-api]', :delayed
end

formatron_sensu_handler 'elasticsearch_metrics' do
  attributes(
    type: 'pipe',
    command: 'elasticsearch_metrics.rb'
  )
  notifies :restart, 'service[sensu-server]', :delayed
  notifies :restart, 'service[sensu-api]', :delayed
end
