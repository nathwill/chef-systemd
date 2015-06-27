
require_relative 'systemd_unit'
require_relative 'systemd_install'

module Systemd
  module Helpers
    def self.validate_config(type = nil, config = [])
      test_module = Object.const_get('Systemd').const_get(type.capitalize)
      opts = test_module::OPTIONS

      config.all? do |c|
        opts.any? { |o| c.start_with? o }
      end
    end
  end
end
