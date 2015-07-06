require 'chef/resource/lwrp_base'
require_relative 'systemd_install'
require_relative 'systemd_unit'
require_relative 'helpers'

class Chef::Resource
  class SystemdUnit < Chef::Resource::LWRPBase
    self.resource_name = :systemd_unit
    provides :systemd_unit

    # TODO: enable, disable, start, stop
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

    # rubocop: disable AbcSize
    # rubocop: disable MethodLength
    def to_hash
      conf = {}

      ['unit', 'install', unit_type.to_s].each do |section|
        # some units types don't have type-specific config blocks
        next if Systemd::Helpers.stub_units.include? section.to_sym

        conf[section] = []

        # handle Alias special case
        if section == 'install' && !aliases.empty?
          conf[section] << "Alias=#{aliases.join(' ')}"
        end

        # convert resource attributes to KV-pair values in the hash
        Systemd.const_get(section.capitalize)::OPTIONS.each do |option|
          attr = send(option.underscore.to_sym)
          conf[section] << "#{option.camelize}=#{attr}" unless attr.nil?
        end
      end

      conf
    end
    # rubocop: enable MethodLength
    # rubocop: enable AbcSize
  end
end
