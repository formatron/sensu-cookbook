graphite_host = node['formatron_sensu']['graphite']['host']
graphite_carbon_port = node['formatron_sensu']['graphite']['carbon_port']
wizard_van_commit = node['formatron_sensu']['wizard_van']['commit']
wizard_van_tarball_checksum = node['formatron_sensu']['wizard_van']['checksum']
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
    rm -rf $DIR
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
