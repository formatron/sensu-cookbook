def whyrun_supported?
  true
end

use_inline_resources

action :install do
  name = new_resource.name
  version = new_resource.version
  gem_package name do
    gem_binary '/opt/sensu/embedded/bin/gem'
    version version
  end
end
