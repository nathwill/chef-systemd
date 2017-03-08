resource_name :systemd_modules
provides :systemd_modules

property :blacklist, [TrueClass, FalseClass], default: false
property :modules, Array, required: true, default: []

default_action :create

%w(create delete).map(&:to_sym).each do |actn|
  action actn do
    r = new_resource

    dir = r.blacklist ? '/etc/modprobe.d' : '/etc/modules-load.d'
    mods = r.blacklist ? r.modules.map { |m| "blacklist #{m}" } : r.modules

    file "#{dir}/#{r.name}.conf" do
      content mods.join("\n")
      action actn
    end
  end
end

action :load do
  new_resource.modules.each do |mod|
    execute "modprobe #{mod}" do
      not_if { SystemdCookbook::Helpers.module_loaded?(mod) }
    end
  end
end

action :unload do
  new_resource.modules.each do |mod|
    execute "modprobe -r #{mod}" do
      only_if { SystemdCookbook::Helpers.module_loaded?(mod) }
    end
  end
end
