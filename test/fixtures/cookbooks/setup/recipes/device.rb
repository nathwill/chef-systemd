

# Test the device resource
systemd_device 'dev-vdb' do
  description 'Test Device'
  install do
    wanted_by 'multi-user.target'
  end
end
