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

    def unit_path(unit)
      ::File.join('/etc/systemd/system', "#{unit.name}.#{unit.unit_type}")
    end

    module_function :ini_config, :unit_types, :stub_units, :unit_path
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
