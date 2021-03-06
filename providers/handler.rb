def whyrun_supported?
  true
end

use_inline_resources

action :add do
  name = new_resource.name
  attributes = new_resource.attributes
  template "/etc/sensu/conf.d/handler_#{name}.json" do
    cookbook 'formatron_sensu'
    source 'handler.json.erb'
    owner 'sensu'
    group 'sensu'
    variables(
      name: name,
      attributes: attributes
    )
  end
end
