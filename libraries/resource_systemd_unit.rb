require 'chef/resource/lwrp_base'
require_relative 'systemd_install'
require_relative 'systemd_unit'
require_relative 'helpers'

class Chef::Resource
  class SystemdUnit < Chef::Resource::LWRPBase
    self.resource_name = :systemd_unit
    provides :systemd_unit

    actions :create, :delete
    default_action :create

    attribute :unit_type, kind_of: Symbol, equal_to: Systemd::Helpers.unit_types, default: :service, required: true # rubocop: disable LineLength
    attribute :aliases, kind_of: Array, default: []
    attribute :drop_in, kind_of: [TrueClass, FalseClass], default: false
    attribute :override, kind_of: String, default: nil
    attribute :overrides, kind_of: Array, default: []

    # define class method for defining resource
    # attributes from the resource module options
    def self.option_attributes(options)
      options.each do |option|
        attribute option.underscore.to_sym, kind_of: String, default: nil
      end
    end

    %w( unit install ).each do |section|
      # convert the section options to resource attributes
      option_attributes Systemd.const_get(section.capitalize)::OPTIONS

      # define organizational attributes to allow
      # attributes to be grouped by section
      define_method(section) do |&b|
        b.call
      end
    end

    def to_hash
      conf = {}

      [:unit, :install, unit_type].each do |section|
        # some unit types don't have type-specific config blocks
        next if Systemd::Helpers.stub_units.include?(section)
        conf[section] = section_values(section)
      end

      conf
    end

    alias_method :to_h, :to_hash

    private

    def section_values(section)
      opts = Systemd.const_get(section.capitalize)::OPTIONS

      [].concat handle_overrides(section, opts)
        .concat handle_alias(section)
        .concat handle_options(opts)
    end

    def handle_overrides(section, opts)
      return [] unless drop_in

      section_overrides = overrides.select do |o|
        opts.include?(o) || (section == 'install' && o == 'Alias')
      end

      section_overrides.map do |over_ride|
        "#{over_ride}="
      end
    end

    def handle_alias(section)
      return [] unless section == 'install' && !aliases.empty?
      ["Alias=#{aliases.join(' ')}"]
    end

    def handle_options(opts)
      opts.reject { |o| send(o.underscore.to_sym).nil? }.map do |opt|
        "#{opt.camelize}=#{send(opt.underscore.to_sym)}"
      end
    end
  end
end
