
# Install a uniformly named package
package 'vsftpd'

# include daemon_reload to apply changes at end of chef run
include_recipe 'systemd::daemon_reload'

# apply a drop-in with auto_reload false,
# without using set_properties to apply
systemd_service 'vsftpd-cpu-tuning' do
  drop_in true
  override 'vsftpd'
  cpu_shares 1200
  cpu_accounting true
  auto_reload false
end
