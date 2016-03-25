#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdSysuser
# Library:: Chef::Provider::SystemdSysuser
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
require 'chef/provider/lwrp_base'

class ChefSystemdCookbook
  # resource for declarative allocation of system users and groups
  # http://www.freedesktop.org/software/systemd/man/sysusers.d.html
  class SysuserResource < Chef::Resource::LWRPBase
    resource_name :systemd_sysuser

    actions :create, :delete
    default_action :create

    attribute :type, kind_of: String, equal_to: %w( u g m r ), default: 'u'
    attribute :name, kind_of: String, name_attribute: true, callbacks: {
      'is less than 31 characters' => ->(spec) { spec.length <= 31 },
      'is only ascii characters' => ->(spec) { spec.ascii_only? },
      'has a non-digit first-char' => ->(spec) { !spec[0].match(/\d/) }
    }, required: true
    attribute :id, kind_of: [String, Integer], callbacks: {
      'is not a reserved id' => lambda do |spec|
        !%w( 65535 4294967295 ).include? spec.to_s
      end
    }
    attribute :gecos, kind_of: String, default: '-'
    attribute :home, kind_of: String, default: '-'

    def as_string
      "#{type} #{name} #{id} \"#{gecos}\" #{home}"
    end
  end

  class SysuserProvider < Chef::Provider::LWRPBase
    DIR ||= '/etc/sysusers.d'.freeze

    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_sysuser if defined?(provides)

    %w( create delete ).map(&:to_sym).each do |a|
      action a do
        r = new_resource

        directory DIR do
          not_if { r.action == :delete }
        end

        path = ::File.join(DIR, "#{r.name}.conf")

        execute "systemd-sysusers #{path}" do
          not_if { r.action == :delete }
          action :nothing
          subscribes :run, "file[#{path}]", :immediately
        end

        f = file path do
          content r.as_string
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end
  end
end
