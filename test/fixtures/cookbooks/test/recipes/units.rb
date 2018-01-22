
systemd_automount 'proc-sys-fs-binfmt_misc' do
  triggers_reload false
  unit do
    default_dependencies false
    before 'sysinit.target'
    condition_path_exists '/proc/sys/fs/binfmt_misc/'
    condition_path_is_read_write '/proc/sys/'
  end
  automount do
    where '/proc/sys/fs/binfmt_misc'
  end
end

systemd_mount 'tmp' do
  unit do
    description 'temp dir'
    documentation 'man:hier(7)'
    condition_path_is_symbolic_link '!/tmp'
    default_dependencies false
    conflicts 'umount.target'
    before %w( local-fs.target umount.target )
  end
  mount do
    what 'tmpfs'
    where '/tmp'
    type 'tmpfs'
    options 'mode=1777,strictatime'
  end
  verify false
end

systemd_service 'systemd-ask-password-console' do
  triggers_reload false
  unit do
    description 'forward password reqs to wall'
    documentation 'man:systemd-ask-password-console.service(8)'
    after %w( systemd-user-session.service )
  end
  service do
    user 'root'
    exec_start_pre '-/usr/bin/systemctl stop systemd-ask-password-console.path systemd-ask-password-console.service systemd-ask-password-plymouth.path systemd-ask-password-plymouth.service'
    exec_start '/usr/bin/systemd-tty-ask-password-agent --wall'
  end
  verify false
end

systemd_path 'systemd-ask-password-console' do
  unit do
    description 'forward password reqs to wall'
    documentation 'man:systemd-ask-password-console.service(8)'
    default_dependencies false
    conflicts 'shutdown.target'
    before %w( paths.target shutdown.target )
  end
  path do
    directory_not_empty '/run/systemd/ask-password'
    make_directory true
  end
  verify false
end

systemd_slice 'user' do
  unit do
    before %w( slices.target )
  end
  slice do
    memory_limit '512M'
  end
end

systemd_socket 'systemd-journald' do
  unit do
    description 'journal socket'
    default_dependencies false
    before %w( sockets.target )
    ignore_on_isolate true
  end
  socket do
    listen_stream '/run/systemd/journal/stdout'
    listen_datagram '/run/systemd/journal/socket'
    socket_mode '0666'
    pass_credentials true
    pass_security true
    receive_buffer '8M'
    service 'systemd-journald.service'
  end
end

systemd_swap 'dev-mapper-swap' do
  swap do
    what '/dev/mapper/swap'
    timeout_sec 60
  end
end

systemd_target 'my-app' do
  unit do
    description 'my cool app'
    after 'network-online.target'
  end
  install do
    wanted_by 'multi-user.target'
  end
end

systemd_timer 'systemd-tmpfiles-clean' do
  unit do
    description 'clean tmpfiles'
  end
  timer do
    on_boot_sec '15m'
    on_unit_active_sec '1d'
  end
end
