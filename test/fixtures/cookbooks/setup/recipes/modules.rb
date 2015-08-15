
# Test removing, unloading
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
