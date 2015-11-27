def whyrun_supported?
  true
end

use_inline_resources

action :add do
  name = new_resource.name
  attrs = new_resource.attributes
  gem = new_resource.gem
  unless gem.nil?
    bundle_dir = ::File.join Sensu::BundleHelper::BUNDLES_ROOT, gem
    original_command = attrs['command'] || attrs[:command]
    fail 'Must supply command if using gem' if original_command.nil?
    attrs['command'] = "cd #{bundle_dir} && #{Sensu::BundleHelper::BUNDLE_BINARY} exec #{original_command}"
  end
  template "/etc/sensu/conf.d/check_#{name}.json" do
    cookbook 'formatron_sensu'
    source 'check.json.erb'
    owner 'sensu'
    group 'sensu'
    variables(
      name: name,
      attributes: attrs
    )
  end
end
