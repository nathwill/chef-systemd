
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

systemd_mount 'tmp' do
  description 'temp dir'
  documentation 'man:hier(7)'
  condition_path_is_symbolic_link '!/tmp'
  default_dependencies false
  conflicts 'umount.target'
  before %w( local-fs.target umount.target )
  mount do
    what 'tmpfs'
    where '/tmp'
    type 'tmpfs'
    options 'mode=1777,strictatime'
  end
end
