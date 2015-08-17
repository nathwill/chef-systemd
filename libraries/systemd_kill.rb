# http://www.freedesktop.org/software/systemd/man/systemd.kill.html
#
# Cookbook Name:: systemd
# Module:: Systemd::Kill
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
  module Kill
    OPTIONS ||= %w(
      KillMode
      KillSignal
      SendSIGHUP
      SendSIGKILL
    )
  end

  def kill_mode(arg = nil)
    set_or_return(
      :kill_mode, arg,
      kind_of: String,
      equal_to: %w( control-group process mixed none )
    )
  end

  def send_sighup(arg = nil)
    set_or_return(
      :send_sighup, arg,
      kind_of: [TrueClass, FalseClass]
    )
  end

  def send_sigkill(arg = nil)
    set_or_return(
      :send_sigkill, arg,
      kind_of: [TrueClass, FalseClass]
    )
  end
end
