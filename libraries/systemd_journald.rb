# http://www.freedesktop.org/software/systemd/man/journald.conf.html
#
# Cookbook Name:: systemd
# Module:: Systemd::Journald
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
  module Journald
    OPTIONS ||= {
      'Storage' => {
        kind_of: String,
        equal_to: %w( volatile persistent auto none )
      },
      'Compress' => { kind_of: [TrueClass, FalseClass] },
      'Seal' => { kind_of: [TrueClass, FalseClass] },
      'SplitMode' => { kind_of: String, equal_to: %w( uid login none ) },
      'RateLimitInterval' => {},
      'RateLimitBurst' => {},
      'SystemMaxUse' => {},
      'SystemKeepFree' => {},
      'SystemMaxFileSize' => {},
      'RuntimeMaxUse' => {},
      'RuntimeKeepFree' => {},
      'RuntimeMaxFileSize' => {},
      'MaxFileSec' => { kind_of: [String, Integer] },
      'MaxRetentionSec' => { kind_of: [String, Integer] },
      'SyncIntervalSec' => { kind_of: [String, Integer] },
      'ForwardToSyslog' => { kind_of: [TrueClass, FalseClass] },
      'ForwardToKMsg' => { kind_of: [TrueClass, FalseClass] },
      'ForwardToConsole' => { kind_of: [TrueClass, FalseClass] },
      'ForwardToWall' => { kind_of: [TrueClass, FalseClass] },
      'MaxLevelStore' => {},
      'MaxLevelSyslog' => {},
      'MaxLevelKMsg' => {},
      'MaxLevelConsole' => {},
      'MaxLevelWall' => {},
      'TTYPath' => {}
    }
  end
end
