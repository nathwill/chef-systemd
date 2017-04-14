#
# Cookbook Name:: systemd
# Library:: SystemdCookbook::Matchers
#
# Copyright 2016 The Authors
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

require_relative 'data'

if defined?(ChefSpec)
  SystemdCookbook::UNITS.each do |type|
    # Define unit matchers
    ChefSpec.define_matcher("systemd_#{type}".to_sym)
    Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
      define_method("#{actn}_systemd_#{type}".to_sym) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(
          "systemd_#{type}".to_sym, actn.to_sym, resource_name
        )
      end
    end

    # Define drop-in matchers
    ChefSpec.define_matcher("systemd_#{type}_drop_in".to_sym)
    %w(create delete).each do |actn|
      define_method("#{actn}_systemd_#{type}_drop_in".to_sym) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(
          "systemd_#{type}_drop_in".to_sym, actn.to_sym, resource_name
        )
      end
    end
  end

  # define daemon drop-in matchers
  SystemdCookbook::DAEMONS.each do |daemon|
    ChefSpec.define_matcher("systemd_#{daemon}".to_sym)
    %w(create delete).each do |actn|
      define_method("#{actn}_systemd_#{daemon}".to_sym) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(
          "systemd_#{daemon}".to_sym, actn.to_sym, resource_name
        )
      end
    end
  end

  # define util matchers
  SystemdCookbook::UTILS.each do |util|
    ChefSpec.define_matcher("systemd_#{util}".to_sym)
    %w(create delete).each do |actn|
      define_method("#{actn}_systemd_#{util}".to_sym) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(
          "systemd_#{util}".to_sym, actn.to_sym, resource_name
        )
      end
    end
  end

  # module actions
  %w(load unload).each do |actn|
    define_method("#{actn}_systemd_modules".to_sym) do |resource_name|
      ChefSpec::Matchers::ResourceMatcher.new(
        :systemd_modules, actn.to_sym, resource_name
      )
    end
  end

  # sysctl actions
  define_method(:apply_systemd_sysctl) do |resource_name|
    ChefSpec::Matchers::ResourceMatcher.new(
      :systemd_sysctl, :apply, resource_name
    )
  end
end
