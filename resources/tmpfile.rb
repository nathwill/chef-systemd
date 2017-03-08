resource_name :systemd_tmpfile
provides :systemd_tmpfile

property :path, String, required: true
property :mode, [String, Numeric], default: '-'
property :uid, String, default: '-'
property :gid, String, default: '-'
property :age, String, default: '-'
property :argument, String, default: '-'
property :type, String, default: 'f', equal_to: %w(
  f F w d D v p,p+ L,L+ c,c+ b,b+ C x X r R z Z t T h H a,a+ A,A+
)

def fpath
  "/etc/tmpfiles.d/#{name}.conf"
end

default_action :create

action :create do
  directory ::File.dirname(new_resource.fpath)

  execute "systemd-tmpfiles --create #{new_resource.fpath}" do
    action :nothing
    subscribes :run, "file[#{new_resource.fpath}]", :immediately
  end

  file new_resource.fpath do
    content [
      new_resource.type,
      new_resource.path,
      new_resource.mode,
      new_resource.uid,
      new_resource.gid,
      new_resource.age,
      new_resource.argument,
    ].join(' ')
  end
end

action :delete do
  execute "systemd-tmpfiles --clean --remove #{new_resource.fpath}" do
    only_if { ::File.exist?(new_resource.fpath) }
  end

  file new_resource.fpath do
    action :delete
  end
end
