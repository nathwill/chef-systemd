module Systemd
  module Helpers
    def ini_config(conf = {})
      conf.delete_if { |_, v| v.empty? }.map do |section, params|
        "[#{section.capitalize}]\n#{params.join("\n")}\n"
      end.join("\n")
    end

    def unit_types
      %i(
        service socket device mount automount
        swap target path timer slice
      )
    end

    def stub_units
      %i( device target )
    end

    def local_conf_root
      '/etc/systemd/system'
    end

    def drop_in_root(unit)
      ::File.join(local_conf_root, "#{unit.override}.d")
    end

    def unit_path(unit)
      if unit.drop_in
        ::File.join(drop_in_root(unit), "#{unit.name}.conf")
      else
        ::File.join(local_conf_root, "#{unit.name}.#{unit.unit_type}")
      end
    end

    module_function :ini_config, :unit_types, :drop_in_root,
                    :unit_path, :local_conf_root, :stub_units
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
