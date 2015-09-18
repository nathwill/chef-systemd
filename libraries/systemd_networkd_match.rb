#
# Cookbook Name:: systemd
# Module:: Systemd::Networkd::Match
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

module Systemd
  module Networkd
    module Match
      OPTIONS ||= {
        'OriginalName' => { kind_of: [String, Array] },
        'Path' => { kind_of: [String, Array] },
        'Driver' => { kind_of: [String, Array] },
        'Type' => { kind_of: [String, Array] },
        'Host' => {},
        'Virtualization' => {
          kind_of: [TrueClass, FalseClass, String],
          equal_to: [
            true, false, 'vm', 'container', 'qemu', 'kvm', 'zvm',
            'vmware', 'microsoft', 'oracle', 'xen', 'bochs', 'uml',
            'openvz', 'lxc', 'lxc-libvirt', 'systemd-nspawn', 'docker'
          ]
        },
        'KernelCommandLine' => {},
        'Architecture' => {
          kind_of: String,
          equal_to: %w(
            x86 x86-64 ppc ppc-le ppc64 ppc64-le ia64 parisc parisc64
            s390 s390x sparc sparc64 mips mips-le mips64 mips64-le
            alpha arm arm-be arm64 arm64-be sh sh64 m86k tilegx cris
          )
        }
      }
    end
  end
end
