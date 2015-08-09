require 'chef/resource/lwrp_base'
require_relative 'systemd_networkd'
require_relative 'helpers'

class Chef::Resource
  class SystemdNetworkdLink < Chef::Resource::LWRPBase
    include Systemd::Networkd

    self.resource_name = :systemd_networkd_link

    provides :systemd_networkd_link

    actions :create, :delete
    default_action :create

    OPTIONS.reject { |o| o.match(/(MACAddress|Alias)/) }.each do |opt|
      attribute opt.underscore.to_sym, kind_of: String, default: nil
    end

    attribute :match_mac_addr, kind_of: String, default: nil
    attribute :link_mac_addr, kind_of: String, default: nil
    attribute :link_alias, kind_of: String, default: nil

    def match
      yield
    end

    def link
      yield
    end

    def to_hash
      conf = {}

      %i( match link ).each do |s|
        conf[s] = section_values(s)
      end

      odd_opts(conf)
    end

    alias_method :to_h, :to_hash

    private

    def section_values(section)
      options_config(Systemd::Networkd.const_get(section.capitalize)::OPTIONS)
    end

    def options_config(options)
      opts = options.reject do |o|
        o.match(/(MACAddress|Alias)/) || send(o.underscore.to_sym).nil?
      end

      opts.map do |opt|
        "#{opt.camelize}=#{send(opt.underscore.to_sym)}"
      end
    end

    # rubocop: disable AbcSize
    def odd_opts(conf)
      match_mac_addr.nil? || conf[:match].push("MACAddress=#{match_mac_addr}")
      link_mac_addr.nil? || conf[:link].push("MACAddress=#{link_mac_addr}")
      link_alias.nil? || conf[:link].push("Alias=#{link_alias}")
      conf
    end
    # rubocop: enable AbcSize
  end
end
