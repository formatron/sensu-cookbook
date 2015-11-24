def whyrun_supported?
  true
end

use_inline_resources

action :add do
  name = new_resource.name
  command = new_resource.command
  type = new_resource.type
  template "/etc/sensu/conf.d/handler_#{name}.json" do
    cookbook 'formatron_sensu'
    source 'handler.json.erb'
    owner 'sensu'
    group 'sensu'
    variables(
      name: name,
      command: command,
      type: type
    )
  end
end
