
systemd_automount_drop_in 'proc-sys-fs-binfmt_misc-override' do
  override 'proc-sys-fs-binfmt_misc.automount'
  timeout_idle_sec '90min'
end

systemd_mount_drop_in 'tmp-override' do
  override 'tmp.mount'
  sloppy_options true
end

systemd_path_drop_in 'systemd-ask-password-console-override' do
  override 'systemd-ask-password-console.path'
  directory_mode '0755'
end

systemd_service_drop_in 'systemd-ask-password-console' do
  override 'systemd-ask-password-console.service'
  description 'blah blah blah'
end

systemd_slice_drop_in '' do

end

systemd_socket_drop_in '' do

end

systemd_swap_drop_in '' do

end

systemd_target_drop_in '' do

end

systemd_timer_drop_in '' do

end
