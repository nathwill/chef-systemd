
# Test the path resource
systemd_path 'dummy' do
  description 'Test Path'
  install do
    wanted_by 'multi-user.target'
  end
  path do
    directory_not_empty '/var/run/queue'
    unit 'queue-worker.service'
    make_directory 'true'
  end
end
