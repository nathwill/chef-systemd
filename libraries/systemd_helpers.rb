
require_relative 'systemd_unit'
require_relative 'systemd_install'

module Systemd
  module Helpers
    def self.unit_types
      [
        :service, :socket, :device, :mount, :automount, :swap,
        :target, :path, :timer, :snapshot, :slice, :scope
      ]
    end

    def self.validate_config(type = nil, config = [])
      test_module = Object.const_get('Systemd').const_get(type.capitalize)
      opts = test_module::OPTIONS

      config.all? do |c|
        opts.any? { |o| c.start_with? o }
      end
    end

    def self.ini_config(r)
      content = {
        'unit' => r.unit,
        'install' => r.install
      }
      content.merge!(r.type => r.send(r.type))
      sections = content.map do |section, params|
        "[#{section.capitalize}]\n#{params.join("\n")}"
      end
      sections.join("\n")
    end
  end
end
