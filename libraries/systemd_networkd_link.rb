#
# Cookbook Name:: systemd
# Module:: Systemd::Networkd::Link
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
    module Link
      OPTIONS ||= {
        'Description' => {},
        'MACAddressPolicy' => {
          kind_of: String,
          equal_to: %w( persistent random )
        },
        'NamePolicy' => {
          kind_of: [String, Array],
          callbacks: {
            'is a valid argument' => lambda do |spec|
              Array(spec).all? do |arg|
                %w( kernel database onboard slot path mac ).include? arg
              end
            end
          }
        },
        'Name' => {},
        'MTUBytes' => { kind_of: [String, Integer] },
        'BitsPerSecond' => { kind_of: [String, Integer] },
        'Duplex' => { kind_of: String, equal_to: %w( half full ) },
        'WakeOnLan' => { kind_of: String, equal_to: %w( phy magic off ) }
      }
    end
  end
end
