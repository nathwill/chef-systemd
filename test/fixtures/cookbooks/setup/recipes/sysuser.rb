
systemd_sysuser '_testuser' do
  id 65_530
  gecos 'my test user'
  home '/var/lib/test'
end
