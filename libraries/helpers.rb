module Systemd
  module Helpers
    DAEMONS ||= %i( journald logind resolved timesyncd )

    UTILS ||= %i( bootchart coredump sleep system user )

    STUB_UNITS ||= %i( device target )

    UNITS ||= %i(
      service socket device mount automount
      swap target path timer slice
    )

    def ini_config(conf = {})
      conf.delete_if { |_, v| v.empty? }.map do |section, params|
        "[#{section.capitalize}]\n#{params.join("\n")}\n"
      end.join("\n")
    end

    def local_conf_root
      '/etc/systemd'
    end

    def unit_conf_root(conf)
      ::File.join(local_conf_root, conf.mode.to_s)
    end

    def conf_drop_in_root(conf)
      if conf.is_a?(Chef::Resource::SystemdUnit)
        ::File.join(
          unit_conf_root(conf),
          "#{conf.override}.#{conf.conf_type}.d"
        )
      else
        ::File.join(local_conf_root, "#{conf.conf_type}.conf.d")
      end
    end

    def conf_path(conf)
      if conf.drop_in
        ::File.join(conf_drop_in_root(conf), "#{conf.name}.conf")
      else
        if conf.is_a?(Chef::Resource::SystemdUnit)
          ::File.join(unit_conf_root(conf), "#{conf.name}.#{conf.conf_type}")
        else
          ::File.join(local_conf_root, "#{conf.conf_type}.conf")
        end
      end
    end

    module_function :ini_config, :local_conf_root, :unit_conf_root,
                    :conf_drop_in_root, :conf_path
  end
end

class String
  def underscore
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end

  def camelize
    gsub(/(^|_)(.)/) { Regexp.last_match(2).upcase }
  end
end
