systemd_service 'test-unit' do
  description 'Test Service'
  documentation 'man:true(1)'
  install do
    aliases %w( testing-unit.service testd.service )
    wanted_by 'multi-user.target'
  end
  service do
    user 'nobody'
    type 'oneshot'
    exec_start '/usr/bin/true'
  end
end

systemd_service 'my-override' do
  drop_in true
  override 'sshd.service'
  overrides %w(
    Alias
  )
  aliases %w( ssh.service openssh.service )
  cpu_quota '10%'
end

systemd_socket 'sshd' do
  description 'SSH Socket for Per-Connection Servers'
  install do
    listen_stream '22'
    accept 'yes'
  end
  socket do
    wanted_by 'sockets.target'
  end
end

systemd_device 'vdb' do
  description 'Test Device'
  install do
    wanted_by 'multi-user.target'
  end
end

systemd_mount 'tmp-mount' do
  unit do
    description 'Test Mount'
    documentation 'man:hier(7)'
    default_dependencies 'no'
    conflicts 'umount.target'
    before 'local-fs.target umount.target'
  end
  install do
    wanted_by 'local-fs.target'
  end
  mount do
    what 'tmpfs'
    where '/tmp'
    type 'tmpfs'
    options 'mode=1777,strictatime'
  end
end

systemd_automount 'vagrant-home' do
  description 'Test Automount'
  install do
    wanted_by 'local-fs.target'
  end
  automount do
    where '/home/vagrant'
  end
end

systemd_swap 'swap' do
  description 'Test Swap'
  install do
    wanted_by 'local-fs.target'
  end
  swap do
    what '/dev/swap'
    timeout_sec '5'
  end
end

systemd_target 'test' do
  description 'Test Target'
  documentation 'man:systemd.special(7)'
  stop_when_unneeded 'yes'
end

systemd_path 'dummy' do
  description 'Test Path'
  install do
    wanted_by 'multi-user.target'
  end
  path do
    directory_not_empty '/var/run/queue'
    unit 'queue-worker.service'
    make_directory 'true'
  end
end

systemd_timer 'clean-tmp' do
  description 'Test Timer'
  documentation 'man:tmpfiles.d(5) man:systemd-tmpfiles(8)'
  timer do
    on_boot_sec '15min'
    on_unit_active_sec '1d'
  end
end

systemd_slice 'customer-1' do
  description 'Test Slice'
  memory_limit '1G'
  cpu_shares '1024'
end
