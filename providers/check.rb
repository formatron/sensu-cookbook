def whyrun_supported?
  true
end

use_inline_resources

action :add do
  type = new_resource.type
  output_type = new_resource.output_type
  auto_tag_host = new_resource.auto_tag_host ? 'yes' : 'no'
  name = new_resource.name
  command = new_resource.command
  interval = new_resource.interval
  subscribers = new_resource.subscribers
  handlers = new_resource.handlers
  template "/etc/sensu/conf.d/check_#{name}.json" do
    cookbook 'formatron_sensu'
    source 'check.json.erb'
    owner 'sensu'
    group 'sensu'
    variables(
      type: type,
      output_type: output_type,
      auto_tag_host: auto_tag_host,
      name: name,
      command: command,
      interval: interval,
      subscribers: subscribers,
      handlers: handlers
    )
  end
end
