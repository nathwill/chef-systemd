
systemd_journald 'local-syslog' do
  drop_in true
  forward_to_syslog 'yes'
  notifies :restart, 'service[systemd-journald]', :delayed
end
