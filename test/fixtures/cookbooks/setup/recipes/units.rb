
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

systemd_service 'systemd-ask-password-console' do
  triggers_reload false
  description 'forward password reqs to wall'
  documentation 'man:systemd-ask-password-console.service(8)'
  after %w( systemd-user-session.service )
  service do
    exec_start_pre '-/usr/bin/systemctl stop systemd-ask-password-console.path systemd-ask-password-console.service systemd-ask-password-plymouth.path systemd-ask-password-plymouth.service'
    exec_start '/usr/bin/systemd-tty-ask-password-agent --wall'
  end
end

systemd_path 'systemd-ask-password-console' do
  description 'forward password reqs to wall'
  documentation 'man:systemd-ask-password-console.service(8)'
  default_dependencies false
  conflicts 'shutdown.target'
  before %w( paths.target shutdown.target )
  path do
    directory_not_empty '/run/systemd/ask-password'
    make_directory true
  end
end
