
include_recipe 'systemd::sysctl'

systemd_sysctl 'vm.swappiness' do
  value 10
  notifies :restart, 'service[systemd-sysctl]', :immediately
end
