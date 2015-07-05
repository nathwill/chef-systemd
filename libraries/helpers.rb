module Systemd
  module Helpers
    def self.ini_config(unit)
      conf = unit.to_hash

      sections = conf.map do |section, params|
        "[#{section.capitalize}]\n#{params.join("\n")}\n"
      end

      sections.join("\n")
    end

    def self.unit_types
      %w(
        service socket device mount automount swap
        target path timer snapshot slice scope
      ).map(&:to_sym)
    end
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
