
systemd_timesyncd 'local-ntp' do
  drop_in true
  ntp 0.upto(3).map { |i| "#{i}.north-america.pool.ntp.org" }.join(' ')
  notifies :restart, 'service[systemd-timesyncd]', :delayed
end
