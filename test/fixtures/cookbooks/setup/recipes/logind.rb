
systemd_logind 'local-ipc' do
  drop_in true
  remove_ipc 'no'
  notifies :restart, 'service[systemd-logind]', :delayed
end
