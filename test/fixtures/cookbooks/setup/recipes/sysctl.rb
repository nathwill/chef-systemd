
include_recipe 'systemd::sysctl'

systemd_sysctl 'vm.swappiness' do
  value 10
  action [:create, :apply]
end
