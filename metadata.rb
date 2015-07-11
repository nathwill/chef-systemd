name 'systemd'
maintainer 'The Authors'
maintainer_email 'nath.e.will@gmail.com'
license 'apache2'
description 'Installs/Configures systemd'
long_description 'Installs/Configures systemd'
version '0.1.1'

%w( redhat centos scientific ).each do |p|
  supports p, '>= 7.0'
end

supports 'debian', '>= 8.0'
supports 'ubuntu', '>= 15.04'

unless defined?(Ridley::Chef::Cookbook::Metadata)
  source_url       'https://github.com/nathwill/chef-systemd'
  issues_url       'https://github.com/nathwill/chef-systemd/issues'
end
