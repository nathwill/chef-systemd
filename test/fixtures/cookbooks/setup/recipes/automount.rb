
systemd_automount 'proc-sys-fs-binfmt_misc' do
  triggers_reload false
  default_dependencies false
  before 'sysinit.target'
  condition_path_exists '/proc/sys/fs/binfmt_misc/'
  condition_path_is_read_write '/proc/sys/'
  automount do
    where '/proc/sys/fs/binfmt_misc'
  end
end
