
systemd_run 'sshd-2222.service' do
  command [
    '/usr/sbin/sshd -D',
    '-o UseDNS=no',
    '-o UsePAM=no',
    '-o PasswordAuthentication=yes',
    '-o UsePrivilegeSeparation=no',
    '-o PidFile=/tmp/sshd.pid',
    '-o Port=2222'
  ].join(' ')
  cpu_shares 1_024
  nice 19
  description 'sshd transient unit'
  service_type 'simple'
  kill_mode 'mixed'
end
