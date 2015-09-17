# http://www.freedesktop.org/software/systemd/man/systemd.socket.html
#
# Cookbook Name:: systemd
# Module:: Systemd::Socket
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

require_relative 'systemd_resource_control'
require_relative 'systemd_exec'
require_relative 'systemd_kill'

module Systemd
  module Socket
    OPTIONS ||= Systemd::ResourceControl::OPTIONS
                .merge(Systemd::Exec::OPTIONS)
                .merge(Systemd::Kill::OPTIONS)
                .merge('ListenStream' => {},
                       'ListenDatagram' => {},
                       'ListenSequentialPacket' => {},
                       'ListenFIFO' => {},
                       'ListenSpecial' => {},
                       'ListenNetlink' => {},
                       'ListenMessageQueue' => {},
                       'BindIPv6Only' => {
                         kind_of: String, equal_to: %w( default both ipv6-only )
                       },
                       'Backlog' => { kind_of: Integer },
                       'BindToDevice' => {},
                       'SocketUser' => {},
                       'SocketGroup' => {},
                       'SocketMode' => { kind_of: [String, Integer] },
                       'DirectoryMode' => { kind_of: [String, Integer] },
                       'Accept' => { kind_of: [TrueClass, FalseClass] },
                       'MaxConnections' => { kind_of: Integer },
                       'KeepAlive' => { kind_of: [TrueClass, FalseClass] },
                       'KeepAliveTimeSec' => { kind_of: Integer },
                       'KeepAliveIntervalSec' => { kind_of: Integer },
                       'KeepAliveProbes' => { kind_of: Integer },
                       'NoDelay' => { kind_of: [TrueClass, FalseClass] },
                       'Priority' => { kind_of: Integer },
                       'DeferAcceptSec' => { kind_of: Integer },
                       'ReceiveBuffer' => { kind_of: Integer },
                       'SendBuffer' => { kind_of: Integer },
                       'IPTOS' => { kind_of: Integer },
                       'IPTTL' => { kind_of: Integer },
                       'Mark' => { kind_of: Integer },
                       'ReusePort' => { kind_of: [TrueClass, FalseClass] },
                       'SmackLabel' => {},
                       'SmackLabelIPIn' => {},
                       'SmackLabelIPOut' => {},
                       'SELinuxContextFromNet' => {
                         kind_of: [TrueClass, FalseClass]
                       },
                       'PipeSize' => { kind_of: [String, Integer] },
                       'MessageQueueMaxMessages' => { kind_of: Integer },
                       'MessageQueueMessageSize' => { kind_of: Integer },
                       'FreeBind' => { kind_of: [TrueClass, FalseClass] },
                       'Transparent' => { kind_of: [TrueClass, FalseClass] },
                       'Broadcast' => { kind_of: [TrueClass, FalseClass] },
                       'PassCredentials' => {
                         kind_of: [TrueClass, FalseClass]
                       },
                       'PassSecurity' => { kind_of: [TrueClass, FalseClass] },
                       'TCPCongestion' => {},
                       'ExecStartPre' => {},
                       'ExecStartPost' => {},
                       'ExecStopPre' => {},
                       'ExecStopPost' => {},
                       'TimeoutSec' => { kind_of: [String, Integer] },
                       'Service' => {},
                       'RemoveOnStop' => { kind_of: [TrueClass, FalseClass] },
                       'Symlinks' => { kind_of: [String, Array] })
  end
end
