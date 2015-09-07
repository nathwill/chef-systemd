
# Test the service resource
systemd_service 'test-unit' do
  # Unit options
  description 'Test Service'
  documentation 'man:true(1)'
  # Install options
  install do
    aliases %w( testing-unit testd )
    wanted_by 'multi-user.target'
  end
  # Service options
  service do
    type 'oneshot'
    exec_start '/usr/bin/true'
    # exec option
    private_tmp true
    user 'nobody'
    # kill option
    kill_signal 'SIGTERM'
    # resource-control option
    memory_limit '5M'
  end
end

# Test drop-in unit
systemd_service 'my-override' do
  description 'Test Override'
  drop_in true
  override 'sshd'
  overrides %w(
    Alias
    Description
  )
  aliases %w( ssh openssh )
  service do
    cpu_quota '10%'
  end
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
