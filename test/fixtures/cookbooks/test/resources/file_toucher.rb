resource_name :test_file_toucher
provides :test_file_toucher

property :time, String, required: true
property :path, String, required: true

default_action :create

action :create do
  systemd_service "file-toucher-#{new_resource.name}" do
    service do
      type 'oneshot'
      exec_start "/bin/touch #{new_resource.path}"
    end
    action :create
  end

  systemd_timer "file-toucher-#{new_resource.name}" do
    timer do
      on_calendar new_resource.time
    end
    action [:create, :enable, :start]
  end
end

action :delete do
  systemd_service "file-toucher-#{new_resource.name}" do
    action :delete
  end

  systemd_timer "file-toucher-#{new_resource.name}" do
    action [:stop, :disable, :delete]
  end
end
