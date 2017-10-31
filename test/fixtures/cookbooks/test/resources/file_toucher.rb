resource_name :test_file_toucher
provides :test_file_toucher

property :time, String, required: true
property :path, String, required: true

default_action :create

action :create do
  systemd_service "file-toucher-#{name}" do
    service do
      type 'oneshot'
      exec_start "/bin/touch #{path}"
    end
    action :create
  end

  systemd_timer "file-toucher-#{name}" do
    timer do
      on_calendar time
    end
    action [:create, :enable, :start]
  end
end

action :delete do
  systemd_service "file-toucher-#{name}" do
    action :delete
  end

  systemd_timer "file-toucher-#{name}" do
    action [:stop, :disable, :delete]
  end
end
