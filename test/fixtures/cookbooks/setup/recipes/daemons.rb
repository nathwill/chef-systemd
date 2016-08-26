
systemd_journald 'my-overrides' do
  compress true
  system_keep_free '1G'
  forward_to_syslog true
end

systemd_logind 'my-overrides' do
  kill_user_processes true
  kill_only_users 'vagrant'
end

systemd_resolved 'my-overrides' do
  dns %w( 208.67.222.222 208.67.220.220 )
  fallback_dns %w( 8.8.8.8 8.8.4.4 )
end

systemd_timesyncd 'my-overrides' do
  ntp 0.upto(3).map { |i| "#{i}.#{node['platform']}.pool.ntp.org" }
  fallback_ntp 0.upto(3).map { |i| "#{i}.pool.ntp.org" }
end
