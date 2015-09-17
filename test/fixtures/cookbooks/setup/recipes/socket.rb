
# Test the socket resource
systemd_socket 'sshd' do
  description 'SSH Socket for Per-Connection Servers'
  install do
    wanted_by 'sockets.target'
  end
  socket do
    listen_stream '22'
    accept true
    protect_system 'full'
    kill_mode 'control-group'
    cpu_quota '20%'
  end
end
