name             'systemd'
maintainer       'The Authors'
maintainer_email 'nath.e.will@gmail.com'
license          'apache2'
description      'resource-driven chef cookbook for managing linux systems via systemd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.0'

supports 'fedora'
supports 'debian', '>= 8.0'
supports 'ubuntu', '>= 15.04'
%w( redhat centos scientific ).each do |p|
  supports p, '>= 7.0'
end

unless defined?(Ridley::Chef::Cookbook::Metadata)
  source_url       'https://github.com/nathwill/chef-systemd' if respond_to?(:source_url)
  issues_url       'https://github.com/nathwill/chef-systemd/issues' if respond_to?(:issues_url)
end
