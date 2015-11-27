def whyrun_supported?
  true
end

use_inline_resources

action :install do
  name = new_resource.name
  gem = new_resource.gem
  version = new_resource.version

  gem_package 'bundler' do
    gem_binary Sensu::BundleHelper::GEM_BINARY
  end

  bundle_dir = ::File.join Sensu::BundleHelper::BUNDLES_ROOT, name
  directory bundle_dir do
    recursive true
  end

  gem_file = ::File.join bundle_dir, 'Gemfile'
  template gem_file do
    cookbook 'formatron_sensu'
    variables(
      gem: gem,
      version: version
    )
    notifies :run, "bash[bundle_install_#{name}]", :immediately
  end

  bash "bundle_install_#{name}" do
    code <<-EOH.gsub(/^ {6}/, '')
      #{Sensu::BundleHelper::RUBY_BINARY} bundle install
    EOH
    cwd bundle_dir
    action :nothing
  end
end
