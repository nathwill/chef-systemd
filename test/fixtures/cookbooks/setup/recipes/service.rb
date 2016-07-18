
# Test the service resource
systemd_service 'test-unit' do
  # Unit options
  description 'Test Service'
  documentation 'man:true(1)'
  # Install options
  install do
    wanted_by 'multi-user.target'
  end
  # Service options
  service do
    type 'oneshot'
    nice -5
    exec_start '/usr/bin/true'
    # exec option
    user 'nobody'
    # kill option
    kill_signal 'SIGTERM'
    # resource-control option
    memory_limit '5M'
  end
end

# Test disabling auto_reload, and set_properties
package 'postfix' # uniformly named package/service

service 'postfix' do
  action :enable
  ignore_failure true # ubuntu is broken
end

# Test masking
package 'vsftpd' # uniformly named package/service

systemd_service 'vsftpd' do
  action [:disable, :stop, :mask]
end

# Test drop-in unit
# Test reload action
systemd_service 'sshd' do
  action :reload
end

# Confirm lifecycle actions not
# supported for drop-in units
begin
  systemd_service 'raises-error' do
    drop_in true
    override 'sshd'
    action [:create, :enable]
  end
rescue Chef::Exceptions::ValidationFailed => e
  # Verify restricted action set for drop-in units
  Chef::Log.warn(e.to_s)
end

# Test the lifecycle events
systemd_service 'rsyslog' do
  action [:disable, :stop]
end
