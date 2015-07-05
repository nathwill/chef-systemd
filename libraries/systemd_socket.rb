# http://www.freedesktop.org/software/systemd/man/systemd.socket.html
require_relative 'systemd_resource_control'
require_relative 'systemd_exec'
require_relative 'systemd_kill'

module Systemd
  module Socket
    OPTIONS ||= Systemd::ResourceControl::OPTIONS |
                Systemd::Exec::OPTIONS |
                Systemd::Kill::OPTIONS | %w(
                  ListenStream
                  ListenDatagram
                  ListenSequentialPacket
                  ListenFIFO
                  ListenSpecial
                  ListenNetlink
                  ListenMessageQueue
                  BindIPv6Only
                  Backlog
                  BindToDevice
                  SocketUser
                  SocketGroup
                  SocketMode
                  DirectoryMode
                  Accept
                  MaxConnections
                  KeepAlive
                  KeepAliveTimeSec
                  KeepAliveIntervalSec
                  KeepAliveProbes
                  NoDelay
                  Priority
                  DeferAcceptSec
                  ReceiveBuffer
                  SendBuffer
                  IPTOS
                  IPTTL
                  Mark
                  ReusePort
                  SmackLabel
                  SmackLabelIPIn
                  SmackLabelIPOut
                  SELinuxContextFromNet
                  PipeSize
                  MessageQueueMaxMessages
                  MessageQueueMessageSize
                  FreeBind
                  Transparent
                  Broadcast
                  PassCredentials
                  PassSecurity
                  TCPCongestion
                  ExecStartPre
                  ExecStartPost
                  ExecStopPre
                  ExecStopPost
                  TimeoutSec
                  Service
                  RemoveOnStop
                  Symlinks
                )
  end
end
