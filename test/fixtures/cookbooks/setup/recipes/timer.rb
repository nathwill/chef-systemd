
# Test the timer resource
systemd_timer 'clean-tmp' do
  description 'Test Timer'
  documentation 'man:tmpfiles.d(5) man:systemd-tmpfiles(8)'
  install do
    wanted_by 'multi-user.target'
  end
  timer do
    on_boot_sec '15min'
    on_unit_active_sec '1d'
  end
end
