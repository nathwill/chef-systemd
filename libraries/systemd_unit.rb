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

module Systemd
  module Unit
    OPTIONS ||= %w(
      Description
      Documentation
      Requires
      RequiresOverridable
      Requisite
      RequisiteOverridable
      Wants
      BindsTo
      PartOf
      Conflicts
      Before
      After
      OnFailure
      PropagatesReloadTo
      ReloadPropagatedFrom
      JoinsNamespaceOf
      RequiresMountsFor
      OnFailureJobMode
      IgnoreOnIsolate
      IgnoreOnSnapshot
      StopWhenUnneeded
      RefuseManualStart
      RefuseManualStop
      AllowIsolate
      DefaultDependencies
      JobTimeoutSec
      JobTimeoutAction
      JobTimeoutRebootArgument
      ConditionArchitecture
      ConditionVirtualization
      ConditionHost
      ConditionKernelCommandLine
      ConditionSecurity
      ConditionCapability
      ConditionACPower
      ConditionNeedsUpdate
      ConditionFirstBoot
      ConditionPathExists
      ConditionPathExistsGlob
      ConditionPathIsDirectory
      ConditionPathIsSymbolicLink
      ConditionPathIsMountPoint
      ConditionPathIsReadWrite
      ConditionDirectoryNotEmpty
      ConditionFileNotEmpty
      ConditionFileIsExecutable
      AssertArchitecture
      AssertVirtualization
      AssertHost
      AssertKernelCommandLine
      AssertSecurity
      AssertCapability
      AssertACPower
      AssertNeedsUpdate
      AssertFirstBoot
      AssertPathExists
      AssertPathExistsGlob
      AssertPathIsDirectory
      AssertPathIsSymbolicLink
      AssertPathIsMountPoint
      AssertPathIsReadWrite
      AssertDirectoryNotEmpty
      AssertFileNotEmpty
      AssertFileIsExecutable
      SourcePath
    )
  end
end
