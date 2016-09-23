
systemd_system 'my-overrides' do
  default_environment({ 'ENVIRONMENT' => 'production' })
  default_timeout_start_sec 30
end

systemd_user 'my-overrides' do
  default_environment({ 'ENVIRONMENT' => 'production' })
  default_timeout_start_sec 120
end

systemd_binfmt 'DOSWin' do
  magic 'MZ'
  interpreter '/usr/bin/wine'
end

systemd_modules 'die-beep-die' do
  blacklist true
  modules %w( pcspkr )
  action [:create, :unload]
end

# Test creating, loading
systemd_modules 'zlib' do
  modules %w( zlib )
  action [:create, :load]
end

systemd_sysctl 'vm.swappiness' do
  value 10
  action [:create, :apply]
end

systemd_sysuser '_testuser' do
  id 65_530
  gecos 'my test user'
  home '/var/lib/test'
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=823322
  not_if { platform_family?('debian') }
end

systemd_tmpfile 'my-app' do
  path '/tmp/my-app'
  age '10d'
  type 'f'
end
