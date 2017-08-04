
systemd_automount_drop_in 'proc-sys-fs-binfmt_misc-override' do
  override 'proc-sys-fs-binfmt_misc.automount'
  automount do
    timeout_idle_sec '90min'
  end
end

systemd_mount_drop_in 'tmp-override' do
  override 'tmp.mount'
  mount do
    sloppy_options true
  end
end

systemd_path_drop_in 'systemd-ask-password-console-override' do
  override 'systemd-ask-password-console.path'
  path do
    directory_mode '0755'
  end
end

systemd_service_drop_in 'systemd-ask-password-console' do
  override 'systemd-ask-password-console.service'
  precursor 'Service' => {'ExecStart' => nil}
  service do
    exec_start '/usr/bin/systemd-tty-ask-password-agent --watch --console'
  end
end

systemd_service_drop_in 'user-service-drop-in' do
  override 'dummy.service'
  user 'vagrant'
  unit do
    description 'user-mode drop-in'
  end
  only_if { platform?('fedora') }
end

systemd_slice_drop_in 'user-memory-limit-local' do
  override 'user.slice'
  slice do
    memory_limit '256G'
  end
end

systemd_socket_drop_in 'systemd-journald' do
  override 'systemd-journald.socket'
  socket do
    receive_buffer '16M'
  end
end

systemd_swap_drop_in 'dev-mapper-swap' do
  override 'dev-mapper-swap.swap'
  swap do
    timeout_sec 120
  end
end

systemd_target_drop_in 'my-app-local' do
  override 'my-app.target'
  unit do
    description 'my really cool app'
  end
end

systemd_timer_drop_in 'systemd-tmpfiles-clean' do
  override 'systemd-tmpfiles-clean.timer'
  timer do
    on_unit_active_sec '1h'
  end
end
