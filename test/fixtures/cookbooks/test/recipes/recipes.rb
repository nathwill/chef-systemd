include_recipe 'systemd::reload'
include_recipe 'systemd::hostname'
include_recipe 'systemd::journald'

# Avoid vagrant-box update-initramfs issues installing systemd-journal-gateway
# Yes, this is evil, but fine for testing! :P
# https://github.com/chef/bento/issues/592
file '/usr/sbin/update-initramfs' do
  mode '0755'
  content <<EOT
#!/bin/sh
true
EOT
  only_if { platform?('debian') }
  action :delete
end
include_recipe 'systemd::journal_gateway'

include_recipe 'systemd::journal_remote'
include_recipe 'systemd::journal_upload'
include_recipe 'systemd::locale'
include_recipe 'systemd::logind'
include_recipe 'systemd::machine'
include_recipe 'systemd::networkd'
include_recipe 'systemd::ntp' unless platform_family?('rhel')
include_recipe 'systemd::resolved'
include_recipe 'systemd::rtc'
include_recipe 'systemd::timezone'
include_recipe 'systemd::vconsole' unless platform_family?('debian')
