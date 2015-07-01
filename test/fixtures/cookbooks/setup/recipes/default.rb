
systemd_service 'test-unit' do
  type :service
  unit %w(
    Description=Test
    Documentation=http://example.com
  )
  install %w(
    Alias=testing-unit.service
    WantedBy=multi-user.target
  )
  service %w(
    Type=oneshot
    ExecStart=/usr/bin/true
  )
end
