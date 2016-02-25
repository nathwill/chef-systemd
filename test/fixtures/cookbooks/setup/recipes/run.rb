
systemd_run 'test-run' do
  command [
    '/usr/sbin/sshd -D',
    '-o UseDNS=no',
    '-o UsePAM=no',
    '-o PasswordAuthentication=yes',
    '-o UsePrivilegeSeparation=no',
    '-o PidFile=/tmp/sshd.pid',
    '-o Port=2222'
  ].join(' ')
  unit 'sshd-2222.service'
  cpu_shares 1_024
  nice 19
  description 'sshd transient unit'
  service_type 'simple'
end
