# http://www.freedesktop.org/software/systemd/man/systemd.unit.html
#
# Cookbook Name:: systemd
# Module:: Systemd::Unit
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

require_relative 'helpers'

# rubocop: disable ModuleLength
module Systemd
  module Unit
    UNIT_LIST ||= {
      kind_of: [String, Array],
      callbacks: {
        'is a valid unit ' => lambda do |spec|
          Array(spec).all? do |unit|
            (Systemd::Helpers::UNITS | Systemd::Helpers::STUB_UNITS).any? do |u| # rubocop: disable LineLength
              unit.match(/\.#{u}$/)
            end
          end
        end
      }
    }

    OPTIONS ||= {
      'Description' => {},
      'Documentation' => { kind_of: [String, Array] },
      'Requires' => UNIT_LIST,
      'RequiresOverridable' => UNIT_LIST,
      'Requisite' => UNIT_LIST,
      'RequisiteOverridable' => UNIT_LIST,
      'Wants' => UNIT_LIST,
      'BindsTo' => UNIT_LIST,
      'PartOf' => UNIT_LIST,
      'Conflicts' => UNIT_LIST,
      'Before' => UNIT_LIST,
      'After' => UNIT_LIST,
      'OnFailure' => UNIT_LIST,
      'PropagatesReloadTo' => UNIT_LIST,
      'ReloadPropagatedFrom' => UNIT_LIST,
      'JoinsNamespaceOf' => UNIT_LIST,
      'RequiresMountsFor' => { kind_of: [String, Array] },
      'OnFailureJobMode' => {
        kind_of: String,
        equal_to: %w(
          fail replace replace-irreversibly isolate
          flush ignore-dependencies ignore-requirements
        )
      },
      'IgnoreOnIsolate' => { kind_of: [TrueClass, FalseClass] },
      'IgnoreOnSnapshot' => { kind_of: [TrueClass, FalseClass] },
      'StopWhenUnneeded' => { kind_of: [TrueClass, FalseClass] },
      'RefuseManualStart' => { kind_of: [TrueClass, FalseClass] },
      'RefuseManualStop' => { kind_of: [TrueClass, FalseClass] },
      'AllowIsolate' => { kind_of: [TrueClass, FalseClass] },
      'DefaultDependencies' => { kind_of: [TrueClass, FalseClass] },
      'JobTimeoutSec' => { kind_of: [String, Integer] },
      'JobTimeoutAction' => {
        kind_of: String,
        equal_to: %w(
          none reboot reboot-force reboot-immediate
          poweroff poweroff-force poweroff-immediate
        )
      },
      'JobTimeoutRebootArgument' => {},
      'ConditionArchitecture' => {
        kind_of: String,
        equal_to: %w(
          x86 x86-64 ppc ppc-le ppc64 ppc64-le ia64 parisc parisc64
          s390 s390x sparc sparc64 mips mips-le mips64 mips64-le
          alpha arm arm-be arm64 arm64-be sh sh64 m86k tilegx cris
        )
      },
      'ConditionVirtualization' => {
        kind_of: [TrueClass, FalseClass, String],
        equal_to: [
          true, false, 'vm', 'container', 'qemu', 'kvm', 'zvm',
          'vmware', 'microsoft', 'oracle', 'xen', 'bochs', 'uml',
          'openvz', 'lxc', 'lxc-libvirt', 'systemd-nspawn', 'docker'
        ]
      },
      'ConditionHost' => {},
      'ConditionKernelCommandLine' => {},
      'ConditionSecurity' => {
        kind_of: String,
        equal_to: %w( selinux apparmor ima smack audit )
      },
      'ConditionCapability' => {},
      'ConditionACPower' => { kind_of: [TrueClass, FalseClass] },
      'ConditionNeedsUpdate' => {
        kind_of: String,
        equal_to: %w( /var /etc !/var !/etc )
      },
      'ConditionFirstBoot' => { kind_of: [TrueClass, FalseClass] },
      'ConditionPathExists' => {},
      'ConditionPathExistsGlob' => {},
      'ConditionPathIsDirectory' => {},
      'ConditionPathIsSymbolicLink' => {},
      'ConditionPathIsMountPoint' => {},
      'ConditionPathIsReadWrite' => {},
      'ConditionDirectoryNotEmpty' => {},
      'ConditionFileNotEmpty' => {},
      'ConditionFileIsExecutable' => {},
      'AssertArchitecture' => {
        kind_of: String,
        equal_to: %w(
          x86 x86-64 ppc ppc-le ppc64 ppc64-le ia64 parisc parisc64
          s390 s390x sparc sparc64 mips mips-le mips64 mips64-le
          alpha arm arm-be arm64 arm64-be sh sh64 m86k tilegx cris
        )
      },
      'AssertVirtualization' => {
        kind_of: [TrueClass, FalseClass, String],
        equal_to: [
          true, false, 'qemu', 'kvm', 'zvm', 'vmware',
          'microsoft', 'oracle', 'xen', 'bochs', 'openvz',
          'lxc', 'lxc-libvirt', 'systemd-nspawn', 'docker', 'uml'
        ]
      },
      'AssertHost' => {},
      'AssertKernelCommandLine' => {},
      'AssertSecurity' => {
        kind_of: String,
        equal_to: %w( selinux apparmor ima smack audit )
      },
      'AssertCapability' => {},
      'AssertACPower' => { kind_of: [TrueClass, FalseClass] },
      'AssertNeedsUpdate' => {
        kind_of: String,
        equal_to: %w( /var /etc !/var !/etc )
      },
      'AssertFirstBoot' => {},
      'AssertPathExists' => {},
      'AssertPathExistsGlob' => {},
      'AssertPathIsDirectory' => {},
      'AssertPathIsSymbolicLink' => {},
      'AssertPathIsMountPoint' => {},
      'AssertPathIsReadWrite' => {},
      'AssertDirectoryNotEmpty' => {},
      'AssertFileNotEmpty' => {},
      'AssertFileIsExecutable' => {},
      'SourcePath' => {}
    }
  end
end
# rubocop: enable ModuleLength
