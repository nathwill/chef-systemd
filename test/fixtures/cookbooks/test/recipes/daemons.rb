
systemd_journald 'my-overrides' do
  journal do
    compress true
    system_keep_free '1G'
    forward_to_syslog true
  end
end

systemd_logind 'my-overrides' do
  login do
    kill_user_processes true
    kill_only_users 'vagrant'
  end
end

systemd_resolved 'my-overrides' do
  resolve do
    dns %w( 208.67.222.222 208.67.220.220 )
    fallback_dns %w( 8.8.8.8 8.8.4.4 )
  end
end

systemd_timesyncd 'my-overrides' do
  time do
    ntp 0.upto(3).map { |i| "#{i}.#{node['platform']}.pool.ntp.org" }
    fallback_ntp 0.upto(3).map { |i| "#{i}.pool.ntp.org" }
  end
end

systemd_coredump 'my-overrides' do
  coredump do
    storage 'external'
    compress true
  end
end

systemd_sleep 'my-overrides' do
  sleep do
    suspend_state 'freeze'
  end
end

systemd_journal_upload 'my-override' do
  upload do
    url 'http://127.0.0.1'
  end
end

systemd_journal_remote 'my-override' do
  remote do
    seal true
    split_mode 'host'
  end
end
