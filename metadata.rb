name             'systemd'
maintainer       'Nathan Williams'
maintainer_email 'nath.e.will@gmail.com'
license          'Apache-2.0'
description      'chef cookbook for managing linux systems via systemd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.2.3'
chef_version     '>= 12.19' if respond_to?(:chef_version)

supports         'arch'
supports         'fedora'
supports         'debian', '>= 8.0'
supports         'ubuntu', '>= 15.04'
%w( redhat centos scientific ).each do |p|
  supports         p, '>= 7.0'
end

gem              'dbus-systemd', '~> 1.1' if respond_to?(:gem)

source_url       'https://github.com/nathwill/chef-systemd' if respond_to?(:source_url)
issues_url       'https://github.com/nathwill/chef-systemd/issues' if respond_to?(:issues_url)
