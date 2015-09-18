#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdNetworkdLink
#
# Copyright 2015 The Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/resource/lwrp_base'
require_relative 'systemd_networkd'
require_relative 'helpers'

# manage systemd networkd device configuration
# http://www.freedesktop.org/software/systemd/man/systemd.link.html
class Chef::Resource
  class SystemdNetworkdLink < Chef::Resource::LWRPBase
    self.resource_name = :systemd_networkd_link
    provides :systemd_networkd_link

    actions :create, :delete
    default_action :create

    %w( match link ).each do |s|
      Systemd::Networkd.const_get(s.capitalize)::OPTIONS.each_pair do |name, config| # rubocop: disable LineLength
        attribute name.underscore.to_sym, config
      end
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
        conf[s] = options_config(
          Systemd::Networkd.const_get(s.capitalize)::OPTIONS
        )
      end

      odd_opts(conf)
    end

    alias_method :to_h, :to_hash

    private

    def options_config(options = {})
      opts = options.reject do |o|
        o.match(/(MACAddress|Alias)/) || send(o.underscore.to_sym).nil?
      end

      opts.map do |name, _|
        "#{name.camelize}=#{send(name.underscore.to_sym)}"
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
