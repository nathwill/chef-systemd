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

# Test the socket resource
systemd_socket 'sshd' do
  # Unit options
  description 'SSH Socket for Per-Connection Servers'
  # Install options
  install do
    wanted_by 'sockets.target'
  end
  # Socket options
  socket do
    listen_stream '22'
    accept 'yes'
    # exec option
    protect_system 'full'
    # kill option
    kill_mode 'control-group'
    # resource-control
    cpu_quota '20%'
  end
end

# Test the device resource
systemd_device 'vdb' do
  # Unit options
  description 'Test Device'
  # Install options
  install do
    wanted_by 'multi-user.target'
  end
end

# Test the mount resource
systemd_mount 'tmp-mount' do
  # Unit options
  description 'Test Mount'
  documentation 'man:hier(7)'
  default_dependencies 'no'
  conflicts 'umount.target'
  before 'local-fs.target umount.target'
  # Install options
  install do
    wanted_by 'local-fs.target'
  end
  # Mount options
  mount do
    timeout_sec '300'
    what 'tmpfs'
    where '/tmp'
    type 'tmpfs'
    options 'mode=1777,strictatime'
    # exec option
    io_scheduling_priority '0'
    # kill option
    kill_mode 'mixed'
    # resource-control option
    slice 'system.slice'
  end
end

# Test the automount resource
systemd_automount 'vagrant-home' do
  # Unit options
  description 'Test Automount'
  # Install options
  install do
    wanted_by 'local-fs.target'
  end
  # Automount options
  automount do
    where '/home/vagrant'
  end
end

# Test the swap resource
systemd_swap 'swap' do
  # Unit option
  description 'Test Swap'
  # Install option
  install do
    wanted_by 'local-fs.target'
  end
  # Swap options
  swap do
    what '/dev/swap'
    timeout_sec '5'
    # exec option
    personality 'x86'
    # kill option
    send_sighup 'no'
    # resource-control option
    block_io_accounting 'true'
  end
end

# Test the target resource
systemd_target 'test' do
  # Unit options
  description 'Test Target'
  documentation 'man:systemd.special(7)'
  stop_when_unneeded 'yes'
  # Install options
  install do
    aliases %w( tested )
  end
end

# Test the path resource
systemd_path 'dummy' do
  # Unit options
  description 'Test Path'
  # Install options
  install do
    wanted_by 'multi-user.target'
  end
  # Path options
  path do
    directory_not_empty '/var/run/queue'
    unit 'queue-worker.service'
    make_directory 'true'
  end
end

# Test the timer resource
systemd_timer 'clean-tmp' do
  # Unit options
  description 'Test Timer'
  documentation 'man:tmpfiles.d(5) man:systemd-tmpfiles(8)'
  # Install options
  install do
    wanted_by 'multi-user.target'
  end
  # Timer options
  timer do
    on_boot_sec '15min'
    on_unit_active_sec '1d'
  end
end

# Test the slice resource
systemd_slice 'customer-1' do
  # Unit options
  description 'Test Slice'
  # Install options
  wanted_by 'multi-user.target'
  # Resource-control options
  memory_limit '1G'
  cpu_shares '1024'
end

# Test the lifecycle events
systemd_service 'rsyslog' do
  action [:disable, :stop]
end
