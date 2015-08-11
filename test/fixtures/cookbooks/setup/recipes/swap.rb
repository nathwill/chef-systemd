
# Test the swap resource
systemd_swap 'swap' do
  description 'Test Swap'
  install do
    wanted_by 'local-fs.target'
  end
  swap do
    what '/dev/swap'
    timeout_sec '5'
    personality 'x86'
    send_sighup 'no'
    block_io_accounting 'true'
  end
end
