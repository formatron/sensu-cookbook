def whyrun_supported?
  true
end

use_inline_resources

action :add do
  name = new_resource.name
  command = new_resource.command
  interval = new_resource.interval
  subscribers = new_resource.subscribers
  template "/etc/sensu/conf.d/check_#{name}.json" do
    cookbook 'formatron_sensu'
    source 'check.json.erb'
    owner 'sensu'
    group 'sensu'
    variables(
      name: name,
      command: command,
      interval: interval,
      subscribers: subscribers
    )
  end
end
