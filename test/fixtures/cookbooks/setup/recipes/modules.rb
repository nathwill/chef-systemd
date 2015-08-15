
# Test removing, unloading
systemd_modules 'die-beep-die' do
  modules %w( pcspkr )
  action [:delete, :unload]
end

# Test creating, loading
systemd_modules 'zlib' do
  modules %w( zlib )
  action [:create, :load]
end
