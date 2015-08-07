
systemd_resolved 'local-llmnr' do
  drop_in true
  llmnr 'resolve'
end
