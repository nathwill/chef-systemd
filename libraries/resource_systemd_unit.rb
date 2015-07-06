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

    attribute(
      :unit_type,
      kind_of: Symbol,
      equal_to: Systemd::Helpers.unit_types,
      default: :service,
      required: true
    )

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

    # rubocop: disable CyclomaticComplexity
    # rubocop: disable PerceivedComplexity
    # rubocop: disable MethodLength
    # rubocop: disable AbcSize
    def to_hash
      conf = {}

      ['unit', 'install', unit_type.to_s].each do |section|
        # some unit types don't have type-specific config blocks
        next if Systemd::Helpers.stub_units.include? section.to_sym

        section_options = Systemd.const_get(section.capitalize)::OPTIONS

        conf[section] = []

        # handle overrides if resource is a drop-in unit
        overrides.each do |over_ride|
          if section_options.include?(over_ride) || over_ride == 'Alias'
            conf[section] << "#{over_ride}="
          end
        end if drop_in

        # handle Alias special case
        if section == 'install' && !aliases.empty?
          conf[section] << "Alias=#{aliases.join(' ')}"
        end

        # convert resource attributes to KV-pair values in the hash
        section_options.each do |option|
          attr = send(option.underscore.to_sym)
          conf[section] << "#{option.camelize}=#{attr}" unless attr.nil?
        end
      end

      conf
    end
    # rubocop: enable AbcSize
    # rubocop: enable MethodLength
    # rubocop: enable PerceivedComplexity
    # rubocop: enable CyclomaticComplexity

    alias_method :to_h, :to_hash
  end
end
