directory '/etc/udev/rules.d/70-persistent-net.rules' do
  action :delete
end

include_recipe 'systemd::reload'
include_recipe 'systemd::hostname'
include_recipe 'systemd::journald'
include_recipe 'systemd::journal_gateway'
include_recipe 'systemd::journal_remote'
include_recipe 'systemd::journal_upload'
include_recipe 'systemd::locale'
include_recipe 'systemd::logind'
include_recipe 'systemd::machine'
include_recipe 'systemd::networkd'
include_recipe 'systemd::timesyncd' unless platform_family?('rhel')
include_recipe 'systemd::resolved'
include_recipe 'systemd::rtc'
include_recipe 'systemd::timezone'
include_recipe 'systemd::vconsole' unless platform_family?('debian')
