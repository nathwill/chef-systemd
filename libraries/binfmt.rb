#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdBinfmt
# Library:: Chef::Provider::SystemdBinfmt
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

# Configure additional binary formats for executables at boot
# http://www.freedesktop.org/software/systemd/man/binfmt.d.html
class ChefSystemdCookbook
  class BinfmtResource < Chef::Resource::LWRPBase
    resource_name :systemd_binfmt

    actions :create, :delete
    default_action :create

    attribute :name, kind_of: String, name_attribute: true,
                     required: true, callbacks: {
                       'does not contain /' => lambda do |spec|
                         !spec.match(Regexp.new('/'))
                       end
                     }
    attribute :type, kind_of: String, equal_to: %w( M E ), default: 'M'
    attribute :offset, kind_of: Integer, equal_to: 0.upto(127)
    attribute :magic, kind_of: String, required: true, callbacks: {
      'does not contain /' => lambda do |spec|
        !spec.match(Regexp.new('/'))
      end
    }
    attribute :mask, kind_of: String, default: nil
    attribute :interpreter, kind_of: String, required: true, callbacks: {
      'does not exceed maximum length' => lambda do |spec|
        spec.length <= 127
      end
    }
    attribute :flags, kind_of: String, callbacks: {
      'only contains supported flags' => lambda do |spec|
        spec.split(//).all? { |c| %w( P O C ).include? c }
      end
    }

    def as_string
      str = %w( name type offset magic mask interpreter flags )
            .map { |a| send(a.to_sym) }

      ":#{str.join(':')}"
    end
  end

  class BinfmtProvider < Chef::Provider::LWRPBase
    DIR ||= '/etc/binfmt.d'.freeze

    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_binfmt if defined?(provides)

    %w( create delete ).map(&:to_sym).each do |a|
      action a do
        r = new_resource

        directory DIR do
          not_if { r.action == :delete }
        end

        f = file ::File.join(DIR, "#{r.name}.conf") do
          content r.as_string
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end
  end
end
