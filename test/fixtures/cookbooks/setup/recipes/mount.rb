
# Test the mount resource
systemd_mount 'tmp-mount' do
  # Unit options
  description 'Test Mount'
  documentation 'man:hier(7)'
  default_dependencies false
  conflicts 'umount.target'
  before 'local-fs.target umount.target'
  # Install options
  install do
    wanted_by 'local-fs.target'
  end
  # Mount options
  mount do
    timeout_sec 300
    what 'tmpfs'
    where '/tmp'
    type 'tmpfs'
    options 'mode=1777,strictatime'
    # exec option
    io_scheduling_priority 0
    # kill option
    kill_mode 'mixed'
    # resource-control option
    slice 'system.slice'
  end
end
