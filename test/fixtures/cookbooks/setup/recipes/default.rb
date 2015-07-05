systemd_service 'test-unit' do
  unit do
    description 'Test'
    documentation 'man:true(1)'
  end
  install do
    wanted_by 'multi-user.target'
  end
  service do
    type 'oneshot'
    exec_start '/usr/bin/true'
  end
end
