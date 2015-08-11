#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdTmpfile
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

# manage systemd-tmpfiles
# http://www.freedesktop.org/software/systemd/man/systemd-tmpfiles.html
# http://www.freedesktop.org/software/systemd/man/tmpfiles.d.html
class Chef::Resource
  class SystemdTmpfile < Chef::Resource::LWRPBase
    self.resource_name = :systemd_tmpfile

    provides :systemd_tmpfile

    actions :create, :delete
    default_action :create

    attribute :path, kind_of: String, required: true, default: nil
    attribute :mode, kind_of: [String, Numeric], default: '-'
    attribute :uid, kind_of: String, default: '-'
    attribute :gid, kind_of: String, default: '-'
    attribute :age, kind_of: String, default: '-'
    attribute :argument, kind_of: String, default: '-'
    attribute :type, kind_of: String, default: 'f',
                     equal_to: %w(
                       f F w d D v p,p+ L,L+ c,c+ b,b+
                       C x X r R z Z t T h H a,a+ A,A+
                     )
  end
end
