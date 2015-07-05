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

    %w( unit install ).each do |section|
      Systemd.const_get(section.capitalize)::OPTIONS.each do |option|
        attribute option.underscore.to_sym, kind_of: String, default: nil
      end
    end

    def unit(&block)
      yield
    end

    def install(&block)
      yield
    end

    def to_hash
      conf = {}
      ['unit', 'install', unit_type.to_s].each do |section|
        conf[section] = []
        Systemd.const_get(section.capitalize)::OPTIONS.each do |option|
          attr = send(option.underscore.to_sym)
          conf[section] << "#{option.camelize}=#{attr}" unless attr.nil?
        end
      end
      conf
    end
  end
end
