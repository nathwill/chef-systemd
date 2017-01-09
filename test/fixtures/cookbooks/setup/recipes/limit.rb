# Test the limit resource
systemd_limit 'vsftpd' do
  nofile '10240:20480'
end
