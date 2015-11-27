def whyrun_supported?
  true
end

use_inline_resources

action :add do
  name = new_resource.name
  attributes = new_resource.attributes.to_hash
  gem = new_resource.gem
  original_command = attributes['command'] || attributes[:command]
  unless gem.nil?
    bundle_dir = ::File.join Sensu::BundleHelper::BUNDLES_ROOT, gem
    original_command = attributes['command'] || attributes[:command]
    fail 'Must supply command if using gem' if original_command.nil?
    attributes['command'] = "cd #{bundle_dir} && #{Sensu::BundleHelper::BUNDLE_BINARY} exec #{original_command}"
  end
  template "/etc/sensu/conf.d/check_#{name}.json" do
    cookbook 'formatron_sensu'
    source 'check.json.erb'
    owner 'sensu'
    group 'sensu'
    variables(
      name: name,
      attributes: attributes
    )
  end
end
