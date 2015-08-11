
# Test the slice resource
systemd_slice 'customer-1' do
  description 'Test Slice'
  wanted_by 'multi-user.target'
  memory_limit '1G'
  cpu_shares '1024'
end
