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
                       'BindIPv6Only' => {},
                       'Backlog' => {},
                       'BindToDevice' => {},
                       'SocketUser' => {},
                       'SocketGroup' => {},
                       'SocketMode' => {},
                       'DirectoryMode' => {},
                       'Accept' => {},
                       'MaxConnections' => {},
                       'KeepAlive' => {},
                       'KeepAliveTimeSec' => {},
                       'KeepAliveIntervalSec' => {},
                       'KeepAliveProbes' => {},
                       'NoDelay' => {},
                       'Priority' => {},
                       'DeferAcceptSec' => {},
                       'ReceiveBuffer' => {},
                       'SendBuffer' => {},
                       'IPTOS' => {},
                       'IPTTL' => {},
                       'Mark' => {},
                       'ReusePort' => {},
                       'SmackLabel' => {},
                       'SmackLabelIPIn' => {},
                       'SmackLabelIPOut' => {},
                       'SELinuxContextFromNet' => {},
                       'PipeSize' => {},
                       'MessageQueueMaxMessages' => {},
                       'MessageQueueMessageSize' => {},
                       'FreeBind' => {},
                       'Transparent' => {},
                       'Broadcast' => {},
                       'PassCredentials' => {},
                       'PassSecurity' => {},
                       'TCPCongestion' => {},
                       'ExecStartPre' => {},
                       'ExecStartPost' => {},
                       'ExecStopPre' => {},
                       'ExecStopPost' => {},
                       'TimeoutSec' => {},
                       'Service' => {},
                       'RemoveOnStop' => {},
                       'Symlinks' => {})
  end
end
