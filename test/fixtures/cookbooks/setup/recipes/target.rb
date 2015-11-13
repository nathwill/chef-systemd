
# Test the target resource
systemd_target 'test' do
  # Unit options
  description 'Test Target'
  documentation 'man:systemd.special(7)'
  stop_when_unneeded true
  # Install options
  install do
    aliases %w( tested )
  end
  action [:create, :set_default]
end
