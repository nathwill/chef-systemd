
systemd_service 'test-unit' do
  description 'Test'
  documentation 'man:true(1)'
  wanted_by 'multi-user.target'
  type 'oneshot'
  exec_start '/usr/bin/true'
end
