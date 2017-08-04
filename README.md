# systemd chef cookbook

[![Cookbook](http://img.shields.io/cookbook/v/systemd.svg)](https://github.com/nathwill/chef-systemd)
[![Build Status](https://travis-ci.org/nathwill/chef-systemd.svg?branch=master)](https://travis-ci.org/nathwill/chef-systemd)

A resource-driven [Chef][chef] cookbook for managing GNU/Linux systems via [systemd][docs].

## Recommended reading

the systemd project covers a lot of territory, below are some resources that can help with orientation.

 - [Overview of systemd for RHEL 7][rhel]
 - [systemd docs][docs]
 - [Lennart's blog series][blog]

We also recommend taking a look at the test cookbook, which doubles as usage examples.

## Overview

### Attributes

The attributes used by this cookbook are under the `systemd` name space (e.g. `node['systemd']['hostname']).

|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|hostname|system hostname, set by hostname recipe unless `nil`|String|nil|
|timezone|system timezone, set by timezone recipe|String|UTC|
|machine_pool_limit|limits overall disk size of the machine pool in machine recipe unless `nil`|String, Integer|nil|
|rtc_mode|sets mode of the real-time-clock, either 'utc' or 'local' in rtc recipe|String|utc|
|fix_rtc|sets whether to correct rtc in rtc recipe|Boolean|false|
|locale|hash of locale settings for `/etc/locale.conf` in locale recipe|Hash|`{'LANG' => 'en_US.UTF-8'}`|
|vconsole|hash of vconsole settings for `/etc/vconsole.conf` in vconsole recipe|Hash|`{'KEYMAP' => 'us', 'FONT' => 'latarcyrheb-sun16'}`|

### Recipes

#### hostname

sets the system hostname with hostnamectl and reloads ohai hostname plugin

#### journal_extra

installs package(s) for extra journald functionality like journal-gateway, journal-remote, journal-upload

#### journal_gateway

includes journal_extra and starts/enables journal-gateway service

#### journal_remote

includes journal_extra and starts/enables journal-remote service

#### journal_upload

includes journal_extra and starts/enables journal-upload service

#### journald

starts/enables journald logging service

#### locale

configures system-wide locale settings via /etc/locale.conf and systemd-localed

#### logind

provides no-op logind service resource as notification target

#### machine

installs btrfs tools required by machined, installs machined utilities, sets machine pool disk size limit from corresponding attribute.

#### networkd

installs/enables/starts networkd

#### reload

schedules an event handler to perform a  systemd manager reload
at the end of the converge. useful for performing a single reload
per converge, as may be desirable when using systemd units with
triggers_reload false.

#### resolved

installs/enables/starts resolved

#### rtc

sets system RTC properties for mode ('utc' or 'local') and whether to correct the RTC

#### timesyncd

enables/starts systemd-timesyncd (NTP-client) service

#### timezone

sets system timezone via timedatectl

#### vconsole

configures the virtual console (keyboard mappings, console font, etc) via `/etc/vconsole.conf` and systemd-vconsole-setup.

### Resources

All resource options for resources configured via INI files support a more convenient notation than enumerating the full property name for every configuration heading. For example, in a service unit:

```ruby
systemd_socket 'sshd' do
  unit_description 'OpenSSH Server Socket'
  unit_documentation 'man:sshd(8) man:sshd_config(5)'
  unit_conflicts 'sshd.service'
  socket_listen_stream 22
  socket_accept true
  install_wanted_by 'sockets.target'
end
```

is the same as:

```ruby
systemd_socket 'sshd' do
  unit do
    description 'OpenSSH Server Socket'
    documentation 'man:sshd(8) man:sshd_config(5)'
    conflicts 'sshd.service'
  end
  socket do
    listen_stream 22
    accept true
  end
  install do
    wanted_by 'sockets.target'
  end
end
```

Prefixing section headings onto property names is necessary to avoid conflicts between properties in different headings of the same resources. For compactness, only the first form is documented for each resource; which form is easiest to use is left for the user to decide.

#### Units & Unit Drop-Ins

|Unit Type|Resource|Drop-In Resource|
|---------|--------|----------------|  
|automount|systemd_automount|systemd_automount_drop_in|
|mount|systemd_mount|systemd_mount_drop_in|
|path|systemd_path|systemd_path_drop_in|
|service|systemd_service|systemd_service_drop_in|
|slice|systemd_slice|systemd_slice_drop_in|
|socket|systemd_socket|systemd_socket_drop_in|
|swap|systemd_swap|systemd_swap_drop_in|
|target|systemd_target|systemd_target_drop_in|
|timer|systemd_timer|systemd_timer_drop_in|

For resetting properties in drop-ins (e.g. `ExecStart`), use the `precursor` property ([example](https://github.com/nathwill/chef-systemd/blob/master/test/fixtures/cookbooks/test/recipes/drop_ins.rb)).

##### systemd_automount

resource for managing [automount][automount] units.

###### Actions

Supports all [systemd_unit actions][sd_unit_actions].

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|automount_where|see docs|nil|String|
|automount_directory_mode|see docs|nil|String|
|automount_timeout_idle_sec|see docs|nil|[String, Integer]|
|unit_description|see docs|nil|String|
|unit_documentation|see docs|nil|[String, Array]|
|unit_requires|see docs|nil|[String, Array]|
|unit_requisite|see docs|nil|[String, Array]|
|unit_wants|see docs|nil|[String, Array]|
|unit_binds_to|see docs|nil|[String, Array]|
|unit_part_of|see docs|nil|[String, Array]|
|unit_conflicts|see docs|nil|[String, Array]|
|unit_before|see docs|nil|[String, Array]|
|unit_after|see docs|nil|[String, Array]|
|unit_on_failure|see docs|nil|[String, Array]|
|unit_propagates_reload_to|see docs|nil|[String, Array]|
|unit_reload_propagated_from|see docs|nil|[String, Array]|
|unit_joins_namespace_of|see docs|nil|[String, Array]|
|unit_requires_mounts_for|see docs|nil|[String, Array]|
|unit_on_failure_job_mode|see docs|nil|String|
|unit_ignore_on_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_stop_when_unneeded|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_start|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_stop|see docs|nil|[TrueClass, FalseClass]|
|unit_allow_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_default_dependencies|see docs|nil|[TrueClass, FalseClass]|
|unit_job_timeout_sec|see docs|nil|[String, Integer]|
|unit_job_timeout_action|see docs|nil|String|
|unit_job_timeout_reboot_argument|see docs|nil|String|
|unit_start_limit_interval_sec|see docs|nil|[String, Integer]|
|unit_start_limit_burst|see docs|nil|Integer|
|unit_start_limit_action|see docs|nil|String|
|unit_reboot_argument|see docs|nil|String|
|unit_condition_architecture|see docs|nil|String|
|unit_condition_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_condition_host|see docs|nil|String|
|unit_condition_kernel_command_line|see docs|nil|String|
|unit_condition_security|see docs|nil|String|
|unit_condition_capability|see docs|nil|[String, Array]|
|unit_condition_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_needs_update|see docs|nil|String|
|unit_condition_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_path_exists|see docs|nil|String|
|unit_condition_path_exists_glob|see docs|nil|String|
|unit_condition_path_is_directory|see docs|nil|String|
|unit_condition_path_is_symbolic_link|see docs|nil|String|
|unit_condition_path_is_mount_point|see docs|nil|String|
|unit_condition_path_is_read_write|see docs|nil|String|
|unit_condition_directory_not_empty|see docs|nil|String|
|unit_condition_file_not_empty|see docs|nil|String|
|unit_condition_file_is_executable|see docs|nil|String|
|unit_assert_architecture|see docs|nil|String|
|unit_assert_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_assert_host|see docs|nil|String|
|unit_assert_kernel_command_line|see docs|nil|String|
|unit_assert_security|see docs|nil|String|
|unit_assert_capability|see docs|nil|[String, Array]|
|unit_assert_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_needs_update|see docs|nil|String|
|unit_assert_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_path_exists|see docs|nil|String|
|unit_assert_path_exists_glob|see docs|nil|String|
|unit_assert_path_is_directory|see docs|nil|String|
|unit_assert_path_is_symbolic_link|see docs|nil|String|
|unit_assert_path_is_mount_point|see docs|nil|String|
|unit_assert_path_is_read_write|see docs|nil|String|
|unit_assert_directory_not_empty|see docs|nil|String|
|unit_assert_file_not_empty|see docs|nil|String|
|unit_assert_file_is_executable|see docs|nil|String|
|unit_source_path|see docs|nil|String|
|install_alias|see docs|nil||[String, Array]|
|install_wanted_by|see docs|nil|[String, Array]|
|install_required_by|see docs|nil|[String, Array]|
|install_also|see docs|nil|[String, Array]|
|install_default_instance|see docs|nil|String|
|triggers_reload|see systemd_unit docs|true|[TrueClass, FalseClass]|
|user|see systemd_unit docs|nil|String|
|verify|see systemd_unit docs|true|[TrueClass, FalseClass]|

##### systemd_automount_drop_in

Resource for managing automount unit drop-in files.

###### Actions

Supports `:create` and `:delete` actions.

###### Properties

See systemd_automount docs for additional properties.

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|override|name of unit resource is drop-in for|nil|String|
|user|see systemd_unit docs|nil|String|
|drop_in_name|combo of override and resource names, used internally by provider|`lazy { "#{override}-#{name}" }`|String|
|precursor|hash of sections/properties to front-load into configuration|{}|Hash|

##### systemd_mount

Resource for managing [mount units][mount].

###### Actions

Supports all [systemd_unit actions][sd_unit_actions].

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|mount_what|see docs|nil|String|
|mount_where|see docs|nil|String|
|mount_type|see docs|nil|String|
|mount_options|see docs|nil|String|
|mount_sloppy_options|see docs|nil|[TrueClass, FalseClass]|
|mount_directory_mode|see docs|nil|String|
|mount_timeout_sec|see docs|nil|[String, Integer]|
|mount_working_directory|see docs|nil|String|
|mount_root_directory|see docs|nil|String|
|mount_user|see docs|nil|[String, Integer]|
|mount_group|see docs|nil|[String, Integer]|
|mount_supplementary_groups|see docs|nil|[String, Array]|
|mount_nice|see docs|nil|Integer|
|mount_oom_score_adjust|see docs|nil|Integer|
|mount_io_scheduling_class|see docs|nil|[Integer, String]|
|mount_io_scheduling_priority|see docs|nil|Integer|
|mount_cpu_scheduling_policy|see docs|nil|String|
|mount_cpu_scheduling_priority|see docs|nil|Integer|
|mount_cpu_scheduling_reset_on_fork|see docs|nil|[TrueClass, FalseClass]|
|mount_cpu_affinity|see docs|nil|[String, Integer, Array]|
|mount_u_mask|see docs|nil|String|
|mount_environment|see docs|nil|[String, Array, Hash]|
|mount_environment_file|see docs|nil|String|
|mount_pass_environment|see docs|nil|[String, Array]|
|mount_standard_input|see docs|nil|String|
|mount_standard_output|see docs|nil|String|
|mount_standard_error|see docs|nil|String|
|mount_tty_path|see docs|nil|String|
|mount_tty_reset|see docs|nil|[TrueClass, FalseClass]|
|mount_ttyv_hangup|see docs|nil|[TrueClass, FalseClass]|
|mount_ttyvt_disallocate|see docs|nil|[TrueClass, FalseClass]|
|mount_syslog_identifier|see docs|nil|String|
|mount_syslog_facility|see docs|nil|String|
|mount_syslog_level|see docs|nil|String|
|mount_syslog_level_prefix|see docs|nil|[TrueClass, FalseClass]|
|mount_timer_slack_n_sec|see docs|nil|[String, Integer]|
|mount_limit_cpu|see docs|nil|[String, Integer]|
|mount_limit_fsize|see docs|nil|[String, Integer]|
|mount_limit_data|see docs|nil|[String, Integer]|
|mount_limit_stack|see docs|nil|[String, Integer]|
|mount_limit_core|see docs|nil|[String, Integer]|
|mount_limit_rss|see docs|nil|[String, Integer]|
|mount_limit_nofile|see docs|nil|[String, Integer]|
|mount_limit_as|see docs|nil|[String, Integer]|
|mount_limit_nproc|see docs|nil|[String, Integer]|
|mount_limit_memlock|see docs|nil|[String, Integer]|
|mount_limit_locks|see docs|nil|[String, Integer]|
|mount_limit_sigpending|see docs|nil|[String, Integer]|
|mount_limit_msgqueue|see docs|nil|[String, Integer]|
|mount_limit_nice|see docs|nil|[String, Integer]|
|mount_limit_rtprio|see docs|nil|[String, Integer]|
|mount_limit_rttime|see docs|nil|[String, Integer]|
|mount_pam_name|see docs|nil|String|
|mount_capability_bounding_set|see docs|nil|[String, Array]|
|mount_ambient_capabilities|see docs|nil|[String, Array]|
|mount_secure_bits|see docs|nil|[String, Array]|
|mount_read_write_directories|see docs|nil|[String, Array]|
|mount_read_only_directories|see docs|nil|[String, Array]|
|mount_inaccessible_directories|see docs|nil|[String, Array]|
|mount_private_tmp|see docs|nil|[TrueClass, FalseClass]|
|mount_private_devices|see docs|nil|[TrueClass, FalseClass]|
|mount_private_network|see docs|nil|[TrueClass, FalseClass]|
|mount_protect_system|see docs|nil|[TrueClass, FalseClass, String]|
|mount_protect_home|see docs|nil|[TrueClass, FalseClass, String]|
|mount_mount_flags|see docs|nil|String|
|mount_utmp_identifier|see docs|nil|String|
|mount_utmp_mode|see docs|nil|String|
|mount_se_linux_context|see docs|nil|String|
|mount_app_armor_profile|see docs|nil|String|
|mount_smack_process_label|see docs|nil|String|
|mount_ignore_sigpipe|see docs|nil|[TrueClass, FalseClass]|
|mount_no_new_privileges|see docs|nil|[TrueClass, FalseClass]|
|mount_system_call_filter|see docs|nil|[String, Array]|
|mount_system_call_error_number|see docs|nil|String|
|mount_system_call_architectures|see docs|nil|String|
|mount_restrict_address_families|see docs|nil|[String, Array]|
|mount_personality|see docs|nil|String|
|mount_runtime_directory|see docs|nil|[String, Array]|
|mount_runtime_directory_mode|see docs|nil|String|
|mount_kill_mode|see docs|nil|String|
|mount_kill_signal|see docs|nil|[String, Integer]|
|mount_send_sighup|see docs|nil|[TrueClass, FalseClass]|
|mount_send_sigkill|see docs|nil|[TrueClass, FalseClass]|
|mount_cpu_accounting|see docs|nil|[TrueClass, FalseClass]|
|mount_cpu_shares|see docs|nil|Integer|
|mount_startup_cpu_shares|see docs|nil|Integer|
|mount_cpu_quota|see docs|nil|String|
|mount_memory_accounting|see docs|nil|[TrueClass, FalseClass]|
|mount_memory_limit|see docs|nil|[String, Integer]|
|mount_tasks_accounting|see docs|nil|[TrueClass, FalseClass]|
|mount_tasks_max|see docs|nil|[String, Integer]|
|mount_io_accounting|see docs|nil|[TrueClass, FalseClass]|
|mount_io_weight|see docs|nil|Integer|
|mount_startup_io_weight|see docs|nil|Integer|
|mount_io_device_weight|see docs|nil|String|
|mount_io_read_bandwidth_max|see docs|nil|[String, Integer]|
|mount_io_write_bandwidth_max|see docs|nil|[String, Integer]|
|mount_io_read_iops_max|see docs|nil|String|
|mount_io_write_iops_max|see docs|nil|String|
|mount_block_io_accounting|see docs|nil|[TrueClass, FalseClass]|
|mount_block_io_weight|see docs|nil|Integer|
|mount_startup_block_io_weight|see docs|nil|Integer|
|mount_block_io_device_weight|see docs|nil|String|
|mount_block_io_read_bandwidth|see docs|nil|String|
|mount_block_io_write_bandwidth|see docs|nil|String|
|mount_device_allow|see docs|nil|String|
|mount_device_policy|see docs|nil|String|
|mount_slice|see docs|nil|String|
|mount_delegate|see docs|nil|[TrueClass, FalseClass]|
|unit_description|see docs|nil|String|
|unit_documentation|see docs|nil|[String, Array]|
|unit_requires|see docs|nil|[String, Array]|
|unit_requisite|see docs|nil|[String, Array]|
|unit_wants|see docs|nil|[String, Array]|
|unit_binds_to|see docs|nil|[String, Array]|
|unit_part_of|see docs|nil|[String, Array]|
|unit_conflicts|see docs|nil|[String, Array]|
|unit_before|see docs|nil|[String, Array]|
|unit_after|see docs|nil|[String, Array]|
|unit_on_failure|see docs|nil|[String, Array]|
|unit_propagates_reload_to|see docs|nil|[String, Array]|
|unit_reload_propagated_from|see docs|nil|[String, Array]|
|unit_joins_namespace_of|see docs|nil|[String, Array]|
|unit_requires_mounts_for|see docs|nil|[String, Array]|
|unit_on_failure_job_mode|see docs|nil|String|
|unit_ignore_on_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_stop_when_unneeded|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_start|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_stop|see docs|nil|[TrueClass, FalseClass]|
|unit_allow_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_default_dependencies|see docs|nil|[TrueClass, FalseClass]|
|unit_job_timeout_sec|see docs|nil|[String, Integer]|
|unit_job_timeout_action|see docs|nil|String|
|unit_job_timeout_reboot_argument|see docs|nil|String|
|unit_start_limit_interval_sec|see docs|nil|[String, Integer]|
|unit_start_limit_burst|see docs|nil|Integer|
|unit_start_limit_action|see docs|nil|String|
|unit_reboot_argument|see docs|nil|String|
|unit_condition_architecture|see docs|nil|String|
|unit_condition_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_condition_host|see docs|nil|String|
|unit_condition_kernel_command_line|see docs|nil|String|
|unit_condition_security|see docs|nil|String|
|unit_condition_capability|see docs|nil|[String, Array]|
|unit_condition_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_needs_update|see docs|nil|String|
|unit_condition_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_path_exists|see docs|nil|String|
|unit_condition_path_exists_glob|see docs|nil|String|
|unit_condition_path_is_directory|see docs|nil|String|
|unit_condition_path_is_symbolic_link|see docs|nil|String|
|unit_condition_path_is_mount_point|see docs|nil|String|
|unit_condition_path_is_read_write|see docs|nil|String|
|unit_condition_directory_not_empty|see docs|nil|String|
|unit_condition_file_not_empty|see docs|nil|String|
|unit_condition_file_is_executable|see docs|nil|String|
|unit_assert_architecture|see docs|nil|String|
|unit_assert_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_assert_host|see docs|nil|String|
|unit_assert_kernel_command_line|see docs|nil|String|
|unit_assert_security|see docs|nil|String|
|unit_assert_capability|see docs|nil|[String, Array]|
|unit_assert_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_needs_update|see docs|nil|String|
|unit_assert_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_path_exists|see docs|nil|String|
|unit_assert_path_exists_glob|see docs|nil|String|
|unit_assert_path_is_directory|see docs|nil|String|
|unit_assert_path_is_symbolic_link|see docs|nil|String|
|unit_assert_path_is_mount_point|see docs|nil|String|
|unit_assert_path_is_read_write|see docs|nil|String|
|unit_assert_directory_not_empty|see docs|nil|String|
|unit_assert_file_not_empty|see docs|nil|String|
|unit_assert_file_is_executable|see docs|nil|String|
|unit_source_path|see docs|nil|String|
|install_alias|see docs|nil||[String, Array]|
|install_wanted_by|see docs|nil|[String, Array]|
|install_required_by|see docs|nil|[String, Array]|
|install_also|see docs|nil|[String, Array]|
|install_default_instance|see docs|nil|String|
|triggers_reload|see systemd_unit docs|true|[TrueClass, FalseClass]|
|user|see systemd_unit docs|nil|String|
|verify|see systemd_unit docs|true|[TrueClass, FalseClass]|

##### systemd_mount_drop_in

Resource for managing mount unit drop-in files.

###### Actions

Supports `:create` and `:delete` actions.

###### Properties

see systemd_mount resource for additional properties.

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|override|name of unit resource is drop-in for|nil|String|
|user|see systemd_unit docs|nil|String|
|drop_in_name|combo of override and resource names, used internally by provider|`lazy { "#{override}-#{name}" }`|String|
|precursor|hash of sections/properties to front-load into configuration|{}|Hash|

##### systemd_path

Resource for managing [path units][path].

###### Actions

Supports all [systemd_unit actions][sd_unit_actions].

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|path_path_exists|see docs|nil|String|
|path_path_exists_glob|see docs|nil|String|
|path_path_changed|see docs|nil|String|
|path_path_modified|see docs|nil|String|
|path_directory_not_empty|see docs|nil|String|
|path_unit|see docs|nil|String|
|path_make_directory|see docs|nil|[TrueClass, FalseClass]|
|path_directory_mode|see docs|nil|String|
|unit_description|see docs|nil|String|
|unit_documentation|see docs|nil|[String, Array]|
|unit_requires|see docs|nil|[String, Array]|
|unit_requisite|see docs|nil|[String, Array]|
|unit_wants|see docs|nil|[String, Array]|
|unit_binds_to|see docs|nil|[String, Array]|
|unit_part_of|see docs|nil|[String, Array]|
|unit_conflicts|see docs|nil|[String, Array]|
|unit_before|see docs|nil|[String, Array]|
|unit_after|see docs|nil|[String, Array]|
|unit_on_failure|see docs|nil|[String, Array]|
|unit_propagates_reload_to|see docs|nil|[String, Array]|
|unit_reload_propagated_from|see docs|nil|[String, Array]|
|unit_joins_namespace_of|see docs|nil|[String, Array]|
|unit_requires_mounts_for|see docs|nil|[String, Array]|
|unit_on_failure_job_mode|see docs|nil|String|
|unit_ignore_on_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_stop_when_unneeded|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_start|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_stop|see docs|nil|[TrueClass, FalseClass]|
|unit_allow_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_default_dependencies|see docs|nil|[TrueClass, FalseClass]|
|unit_job_timeout_sec|see docs|nil|[String, Integer]|
|unit_job_timeout_action|see docs|nil|String|
|unit_job_timeout_reboot_argument|see docs|nil|String|
|unit_start_limit_interval_sec|see docs|nil|[String, Integer]|
|unit_start_limit_burst|see docs|nil|Integer|
|unit_start_limit_action|see docs|nil|String|
|unit_reboot_argument|see docs|nil|String|
|unit_condition_architecture|see docs|nil|String|
|unit_condition_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_condition_host|see docs|nil|String|
|unit_condition_kernel_command_line|see docs|nil|String|
|unit_condition_security|see docs|nil|String|
|unit_condition_capability|see docs|nil|[String, Array]|
|unit_condition_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_needs_update|see docs|nil|String|
|unit_condition_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_path_exists|see docs|nil|String|
|unit_condition_path_exists_glob|see docs|nil|String|
|unit_condition_path_is_directory|see docs|nil|String|
|unit_condition_path_is_symbolic_link|see docs|nil|String|
|unit_condition_path_is_mount_point|see docs|nil|String|
|unit_condition_path_is_read_write|see docs|nil|String|
|unit_condition_directory_not_empty|see docs|nil|String|
|unit_condition_file_not_empty|see docs|nil|String|
|unit_condition_file_is_executable|see docs|nil|String|
|unit_assert_architecture|see docs|nil|String|
|unit_assert_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_assert_host|see docs|nil|String|
|unit_assert_kernel_command_line|see docs|nil|String|
|unit_assert_security|see docs|nil|String|
|unit_assert_capability|see docs|nil|[String, Array]|
|unit_assert_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_needs_update|see docs|nil|String|
|unit_assert_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_path_exists|see docs|nil|String|
|unit_assert_path_exists_glob|see docs|nil|String|
|unit_assert_path_is_directory|see docs|nil|String|
|unit_assert_path_is_symbolic_link|see docs|nil|String|
|unit_assert_path_is_mount_point|see docs|nil|String|
|unit_assert_path_is_read_write|see docs|nil|String|
|unit_assert_directory_not_empty|see docs|nil|String|
|unit_assert_file_not_empty|see docs|nil|String|
|unit_assert_file_is_executable|see docs|nil|String|
|unit_source_path|see docs|nil|String|
|install_alias|see docs|nil||[String, Array]|
|install_wanted_by|see docs|nil|[String, Array]|
|install_required_by|see docs|nil|[String, Array]|
|install_also|see docs|nil|[String, Array]|
|install_default_instance|see docs|nil|String|
|triggers_reload|see systemd_unit docs|true|[TrueClass, FalseClass]|
|user|see systemd_unit docs|nil|String|
|verify|see systemd_unit docs|true|[TrueClass, FalseClass]|

##### systemd_path_drop_in

Resource for managing path unit drop-in files.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

see systemd_path resource for additional properties.

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|override|name of unit resource is drop-in for|nil|String|
|user|see systemd_unit docs|nil|String|
|drop_in_name|combo of override and resource names, used internally by provider|`lazy { "#{override}-#{name}" }`|String|
|precursor|hash of sections/properties to front-load into configuration|{}|Hash|

##### systemd_service

Resource for managing [service units][service].

###### Actions

Supports all [systemd_unit actions][sd_unit_actions].

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|service_type|see docs|nil|String|
|service_remain_after_exit|see docs|nil|[TrueClass, FalseClass]|
|service_guess_main_pid|see docs|nil|[TrueClass, FalseClass]|
|service_pid_file|see docs|nil|String|
|service_bus_name|see docs|nil|String|
|service_exec_start|see docs|nil|String|
|service_exec_start_pre|see docs|nil|String|
|service_exec_start_post|see docs|nil|String|
|service_exec_reload|see docs|nil|String|
|service_exec_stop|see docs|nil|String|
|service_exec_stop_post|see docs|nil|String|
|service_restart_sec|see docs|nil|[String, Integer]|
|service_timeout_start_sec|see docs|nil|[String, Integer]|
|service_timeout_stop_sec|see docs|nil|[String, Integer]|
|service_timeout_sec|see docs|nil|[String, Integer]|
|service_runtime_max_sec|see docs|nil|[String, Integer]|
|service_watchdog_sec|see docs|nil|[String, Integer]|
|service_restart|see docs|nil|String|
|service_success_exit_status|see docs|nil|[String, Array, Integer]|
|service_restart_prevent_exit_status|see docs|nil|[String, Array, Integer]|
|service_restart_force_exit_status|see docs|nil|[String, Array, Integer]|
|service_permissions_start_only|see docs|nil|[TrueClass, FalseClass]|
|service_root_directory_start_only|see docs|nil|[TrueClass, FalseClass]|
|service_non_blocking|see docs|nil|[TrueClass, FalseClass]|
|service_notify_access|see docs|nil|String|
|service_sockets|see docs|nil|[String, Array]|
|service_failure_action|see docs|nil|String|
|service_file_descriptor_store_max|see docs|nil|Integer|
|service_usb_function_descriptors|see docs|nil|String|
|service_usb_function_strings|see docs|nil|String|
|service_working_directory|see docs|nil|String|
|service_root_directory|see docs|nil|String|
|service_user|see docs|nil|[String, Integer]|
|service_group|see docs|nil|[String, Integer]|
|service_supplementary_groups|see docs|nil|[String, Array]|
|service_nice|see docs|nil|Integer|
|service_oom_score_adjust|see docs|nil|Integer|
|service_io_scheduling_class|see docs|nil|[Integer, String]|
|service_io_scheduling_priority|see docs|nil|Integer|
|service_cpu_scheduling_policy|see docs|nil|String|
|service_cpu_scheduling_priority|see docs|nil|Integer|
|service_cpu_scheduling_reset_on_fork|see docs|nil|[TrueClass, FalseClass]|
|service_cpu_affinity|see docs|nil|[String, Integer, Array]|
|service_u_mask|see docs|nil|String|
|service_environment|see docs|nil|[String, Array, Hash]|
|service_environment_file|see docs|nil|String|
|service_pass_environment|see docs|nil|[String, Array]|
|service_standard_input|see docs|nil|String|
|service_standard_output|see docs|nil|String|
|service_standard_error|see docs|nil|String|
|service_tty_path|see docs|nil|String|
|service_tty_reset|see docs|nil|[TrueClass, FalseClass]|
|service_ttyv_hangup|see docs|nil|[TrueClass, FalseClass]|
|service_ttyvt_disallocate|see docs|nil|[TrueClass, FalseClass]|
|service_syslog_identifier|see docs|nil|String|
|service_syslog_facility|see docs|nil|String|
|service_syslog_level|see docs|nil|String|
|service_syslog_level_prefix|see docs|nil|[TrueClass, FalseClass]|
|service_timer_slack_n_sec|see docs|nil|[String, Integer]|
|service_limit_cpu|see docs|nil|[String, Integer]|
|service_limit_fsize|see docs|nil|[String, Integer]|
|service_limit_data|see docs|nil|[String, Integer]|
|service_limit_stack|see docs|nil|[String, Integer]|
|service_limit_core|see docs|nil|[String, Integer]|
|service_limit_rss|see docs|nil|[String, Integer]|
|service_limit_nofile|see docs|nil|[String, Integer]|
|service_limit_as|see docs|nil|[String, Integer]|
|service_limit_nproc|see docs|nil|[String, Integer]|
|service_limit_memlock|see docs|nil|[String, Integer]|
|service_limit_locks|see docs|nil|[String, Integer]|
|service_limit_sigpending|see docs|nil|[String, Integer]|
|service_limit_msgqueue|see docs|nil|[String, Integer]|
|service_limit_nice|see docs|nil|[String, Integer]|
|service_limit_rtprio|see docs|nil|[String, Integer]|
|service_limit_rttime|see docs|nil|[String, Integer]|
|service_pam_name|see docs|nil|String|
|service_capability_bounding_set|see docs|nil|[String, Array]|
|service_ambient_capabilities|see docs|nil|[String, Array]|
|service_secure_bits|see docs|nil|[String, Array]|
|service_read_write_directories|see docs|nil|[String, Array]|
|service_read_only_directories|see docs|nil|[String, Array]|
|service_inaccessible_directories|see docs|nil|[String, Array]|
|service_private_tmp|see docs|nil|[TrueClass, FalseClass]|
|service_private_devices|see docs|nil|[TrueClass, FalseClass]|
|service_private_network|see docs|nil|[TrueClass, FalseClass]|
|service_protect_system|see docs|nil|[TrueClass, FalseClass, String]|
|service_protect_home|see docs|nil|[TrueClass, FalseClass, String]|
|service_mount_flags|see docs|nil|String|
|service_utmp_identifier|see docs|nil|String|
|service_utmp_mode|see docs|nil|String|
|service_se_linux_context|see docs|nil|String|
|service_app_armor_profile|see docs|nil|String|
|service_smack_process_label|see docs|nil|String|
|service_ignore_sigpipe|see docs|nil|[TrueClass, FalseClass]|
|service_no_new_privileges|see docs|nil|[TrueClass, FalseClass]|
|service_system_call_filter|see docs|nil|[String, Array]|
|service_system_call_error_number|see docs|nil|String|
|service_system_call_architectures|see docs|nil|String|
|service_restrict_address_families|see docs|nil|[String, Array]|
|service_personality|see docs|nil|String|
|service_runtime_directory|see docs|nil|[String, Array]|
|service_runtime_directory_mode|see docs|nil|String|
|service_kill_mode|see docs|nil|String|
|service_kill_signal|see docs|nil|[String, Integer]|
|service_send_sighup|see docs|nil|[TrueClass, FalseClass]|
|service_send_sigkill|see docs|nil|[TrueClass, FalseClass]|
|service_cpu_accounting|see docs|nil|[TrueClass, FalseClass]|
|service_cpu_shares|see docs|nil|Integer|
|service_startup_cpu_shares|see docs|nil|Integer|
|service_cpu_quota|see docs|nil|String|
|service_memory_accounting|see docs|nil|[TrueClass, FalseClass]|
|service_memory_limit|see docs|nil|[String, Integer]|
|service_tasks_accounting|see docs|nil|[TrueClass, FalseClass]|
|service_tasks_max|see docs|nil|[String, Integer]|
|service_io_accounting|see docs|nil|[TrueClass, FalseClass]|
|service_io_weight|see docs|nil|Integer|
|service_startup_io_weight|see docs|nil|Integer|
|service_io_device_weight|see docs|nil|String|
|service_io_read_bandwidth_max|see docs|nil|[String, Integer]|
|service_io_write_bandwidth_max|see docs|nil|[String, Integer]|
|service_io_read_iops_max|see docs|nil|String|
|service_io_write_iops_max|see docs|nil|String|
|service_block_io_accounting|see docs|nil|[TrueClass, FalseClass]|
|service_block_io_weight|see docs|nil|Integer|
|service_startup_block_io_weight|see docs|nil|Integer|
|service_block_io_device_weight|see docs|nil|String|
|service_block_io_read_bandwidth|see docs|nil|String|
|service_block_io_write_bandwidth|see docs|nil|String|
|service_device_allow|see docs|nil|String|
|service_device_policy|see docs|nil|String|
|service_slice|see docs|nil|String|
|service_delegate|see docs|nil|[TrueClass, FalseClass]|
|unit_description|see docs|nil|String|
|unit_documentation|see docs|nil|[String, Array]|
|unit_requires|see docs|nil|[String, Array]|
|unit_requisite|see docs|nil|[String, Array]|
|unit_wants|see docs|nil|[String, Array]|
|unit_binds_to|see docs|nil|[String, Array]|
|unit_part_of|see docs|nil|[String, Array]|
|unit_conflicts|see docs|nil|[String, Array]|
|unit_before|see docs|nil|[String, Array]|
|unit_after|see docs|nil|[String, Array]|
|unit_on_failure|see docs|nil|[String, Array]|
|unit_propagates_reload_to|see docs|nil|[String, Array]|
|unit_reload_propagated_from|see docs|nil|[String, Array]|
|unit_joins_namespace_of|see docs|nil|[String, Array]|
|unit_requires_mounts_for|see docs|nil|[String, Array]|
|unit_on_failure_job_mode|see docs|nil|String|
|unit_ignore_on_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_stop_when_unneeded|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_start|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_stop|see docs|nil|[TrueClass, FalseClass]|
|unit_allow_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_default_dependencies|see docs|nil|[TrueClass, FalseClass]|
|unit_job_timeout_sec|see docs|nil|[String, Integer]|
|unit_job_timeout_action|see docs|nil|String|
|unit_job_timeout_reboot_argument|see docs|nil|String|
|unit_start_limit_interval_sec|see docs|nil|[String, Integer]|
|unit_start_limit_burst|see docs|nil|Integer|
|unit_start_limit_action|see docs|nil|String|
|unit_reboot_argument|see docs|nil|String|
|unit_condition_architecture|see docs|nil|String|
|unit_condition_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_condition_host|see docs|nil|String|
|unit_condition_kernel_command_line|see docs|nil|String|
|unit_condition_security|see docs|nil|String|
|unit_condition_capability|see docs|nil|[String, Array]|
|unit_condition_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_needs_update|see docs|nil|String|
|unit_condition_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_path_exists|see docs|nil|String|
|unit_condition_path_exists_glob|see docs|nil|String|
|unit_condition_path_is_directory|see docs|nil|String|
|unit_condition_path_is_symbolic_link|see docs|nil|String|
|unit_condition_path_is_mount_point|see docs|nil|String|
|unit_condition_path_is_read_write|see docs|nil|String|
|unit_condition_directory_not_empty|see docs|nil|String|
|unit_condition_file_not_empty|see docs|nil|String|
|unit_condition_file_is_executable|see docs|nil|String|
|unit_assert_architecture|see docs|nil|String|
|unit_assert_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_assert_host|see docs|nil|String|
|unit_assert_kernel_command_line|see docs|nil|String|
|unit_assert_security|see docs|nil|String|
|unit_assert_capability|see docs|nil|[String, Array]|
|unit_assert_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_needs_update|see docs|nil|String|
|unit_assert_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_path_exists|see docs|nil|String|
|unit_assert_path_exists_glob|see docs|nil|String|
|unit_assert_path_is_directory|see docs|nil|String|
|unit_assert_path_is_symbolic_link|see docs|nil|String|
|unit_assert_path_is_mount_point|see docs|nil|String|
|unit_assert_path_is_read_write|see docs|nil|String|
|unit_assert_directory_not_empty|see docs|nil|String|
|unit_assert_file_not_empty|see docs|nil|String|
|unit_assert_file_is_executable|see docs|nil|String|
|unit_source_path|see docs|nil|String|
|install_alias|see docs|nil||[String, Array]|
|install_wanted_by|see docs|nil|[String, Array]|
|install_required_by|see docs|nil|[String, Array]|
|install_also|see docs|nil|[String, Array]|
|install_default_instance|see docs|nil|String|
|triggers_reload|see systemd_unit docs|true|[TrueClass, FalseClass]|
|user|see systemd_unit docs|nil|String|
|verify|see systemd_unit docs|true|[TrueClass, FalseClass]|

##### systemd_service_drop_in

Resource for managing service unit drop-in files.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

see systemd_service resource for additional properties.

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|override|name of unit resource is drop-in for|nil|String|
|user|see systemd_unit docs|nil|String|
|drop_in_name|combo of override and resource names, used internally by provider|`lazy { "#{override}-#{name}" }`|String|
|precursor|hash of sections/properties to front-load into configuration|{}|Hash|

##### systemd_slice

Resource for managing [slice units][slice].

###### Actions

Supports all [systemd_unit actions][sd_unit_actions].

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|slice_cpu_accounting|see docs|nil|[TrueClass, FalseClass]|
|slice_cpu_shares|see docs|nil|Integer|
|slice_startup_cpu_shares|see docs|nil|Integer|
|slice_cpu_quota|see docs|nil|String|
|slice_memory_accounting|see docs|nil|[TrueClass, FalseClass]|
|slice_memory_limit|see docs|nil|[String, Integer]|
|slice_tasks_accounting|see docs|nil|[TrueClass, FalseClass]|
|slice_tasks_max|see docs|nil|[String, Integer]|
|slice_io_accounting|see docs|nil|[TrueClass, FalseClass]|
|slice_io_weight|see docs|nil|Integer|
|slice_startup_io_weight|see docs|nil|Integer|
|slice_io_device_weight|see docs|nil|String|
|slice_io_read_bandwidth_max|see docs|nil|[String, Integer]|
|slice_io_write_bandwidth_max|see docs|nil|[String, Integer]|
|slice_io_read_iops_max|see docs|nil|String|
|slice_io_write_iops_max|see docs|nil|String|
|slice_block_io_accounting|see docs|nil|[TrueClass, FalseClass]|
|slice_block_io_weight|see docs|nil|Integer|
|slice_startup_block_io_weight|see docs|nil|Integer|
|slice_block_io_device_weight|see docs|nil|String|
|slice_block_io_read_bandwidth|see docs|nil|String|
|slice_block_io_write_bandwidth|see docs|nil|String|
|slice_device_allow|see docs|nil|String|
|slice_device_policy|see docs|nil|String|
|slice_slice|see docs|nil|String|
|slice_delegate|see docs|nil|[TrueClass, FalseClass]|
|unit_description|see docs|nil|String|
|unit_documentation|see docs|nil|[String, Array]|
|unit_requires|see docs|nil|[String, Array]|
|unit_requisite|see docs|nil|[String, Array]|
|unit_wants|see docs|nil|[String, Array]|
|unit_binds_to|see docs|nil|[String, Array]|
|unit_part_of|see docs|nil|[String, Array]|
|unit_conflicts|see docs|nil|[String, Array]|
|unit_before|see docs|nil|[String, Array]|
|unit_after|see docs|nil|[String, Array]|
|unit_on_failure|see docs|nil|[String, Array]|
|unit_propagates_reload_to|see docs|nil|[String, Array]|
|unit_reload_propagated_from|see docs|nil|[String, Array]|
|unit_joins_namespace_of|see docs|nil|[String, Array]|
|unit_requires_mounts_for|see docs|nil|[String, Array]|
|unit_on_failure_job_mode|see docs|nil|String|
|unit_ignore_on_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_stop_when_unneeded|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_start|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_stop|see docs|nil|[TrueClass, FalseClass]|
|unit_allow_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_default_dependencies|see docs|nil|[TrueClass, FalseClass]|
|unit_job_timeout_sec|see docs|nil|[String, Integer]|
|unit_job_timeout_action|see docs|nil|String|
|unit_job_timeout_reboot_argument|see docs|nil|String|
|unit_start_limit_interval_sec|see docs|nil|[String, Integer]|
|unit_start_limit_burst|see docs|nil|Integer|
|unit_start_limit_action|see docs|nil|String|
|unit_reboot_argument|see docs|nil|String|
|unit_condition_architecture|see docs|nil|String|
|unit_condition_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_condition_host|see docs|nil|String|
|unit_condition_kernel_command_line|see docs|nil|String|
|unit_condition_security|see docs|nil|String|
|unit_condition_capability|see docs|nil|[String, Array]|
|unit_condition_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_needs_update|see docs|nil|String|
|unit_condition_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_path_exists|see docs|nil|String|
|unit_condition_path_exists_glob|see docs|nil|String|
|unit_condition_path_is_directory|see docs|nil|String|
|unit_condition_path_is_symbolic_link|see docs|nil|String|
|unit_condition_path_is_mount_point|see docs|nil|String|
|unit_condition_path_is_read_write|see docs|nil|String|
|unit_condition_directory_not_empty|see docs|nil|String|
|unit_condition_file_not_empty|see docs|nil|String|
|unit_condition_file_is_executable|see docs|nil|String|
|unit_assert_architecture|see docs|nil|String|
|unit_assert_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_assert_host|see docs|nil|String|
|unit_assert_kernel_command_line|see docs|nil|String|
|unit_assert_security|see docs|nil|String|
|unit_assert_capability|see docs|nil|[String, Array]|
|unit_assert_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_needs_update|see docs|nil|String|
|unit_assert_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_path_exists|see docs|nil|String|
|unit_assert_path_exists_glob|see docs|nil|String|
|unit_assert_path_is_directory|see docs|nil|String|
|unit_assert_path_is_symbolic_link|see docs|nil|String|
|unit_assert_path_is_mount_point|see docs|nil|String|
|unit_assert_path_is_read_write|see docs|nil|String|
|unit_assert_directory_not_empty|see docs|nil|String|
|unit_assert_file_not_empty|see docs|nil|String|
|unit_assert_file_is_executable|see docs|nil|String|
|unit_source_path|see docs|nil|String|
|install_alias|see docs|nil||[String, Array]|
|install_wanted_by|see docs|nil|[String, Array]|
|install_required_by|see docs|nil|[String, Array]|
|install_also|see docs|nil|[String, Array]|
|install_default_instance|see docs|nil|String|
|triggers_reload|see systemd_unit docs|true|[TrueClass, FalseClass]|
|user|see systemd_unit docs|nil|String|
|verify|see systemd_unit docs|true|[TrueClass, FalseClass]|

##### systemd_slice_drop_in

Resource for managing slice unit drop-in files.

###### Actions

Supports `:create` and `:delete` actions.

###### Properties

see systemd_slice resource for additional properties.

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|override|name of unit resource is drop-in for|nil|String|
|user|see systemd_unit docs|nil|String|
|drop_in_name|combo of override and resource names, used internally by provider|`lazy { "#{override}-#{name}" }`|String|
|precursor|hash of sections/properties to front-load into configuration|{}|Hash|

##### systemd_socket

Resource for managing [socket units][socket].

###### Actions

Supports all [systemd_unit actions][sd_unit_actions].

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|socket_listen_stream|see docs|nil|[String, Integer]|
|socket_listen_datagram|see docs|nil|[String, Integer]|
|socket_listen_sequential_packet|see docs|nil|[String, Integer]|
|socket_listen_fifo|see docs|nil|String|
|socket_listen_special|see docs|nil|String|
|socket_listen_netlink|see docs|nil|String|
|socket_listen_message_queue|see docs|nil|String|
|socket_listen_usb_function|see docs|nil|String|
|socket_socket_protocol|see docs|nil|String|
|socket_bind_i_pv6_only|see docs|nil|String|
|socket_backlog|see docs|nil|Integer|
|socket_bind_to_device|see docs|nil|String|
|socket_socket_user|see docs|nil|String|
|socket_socket_group|see docs|nil|String|
|socket_socket_mode|see docs|nil|String|
|socket_directory_mode|see docs|nil|String|
|socket_accept|see docs|nil|[TrueClass, FalseClass]|
|socket_writable|see docs|nil|[TrueClass, FalseClass]|
|socket_max_connections|see docs|nil|Integer|
|socket_keep_alive|see docs|nil|[TrueClass, FalseClass]|
|socket_keep_alive_time_sec|see docs|nil|[String, Integer]|
|socket_keep_alive_interval_sec|see docs|nil|[String, Integer]|
|socket_keep_alive_probes|see docs|nil|Integer|
|socket_no_delay|see docs|nil|[TrueClass, FalseClass]|
|socket_priority|see docs|nil|Integer|
|socket_defer_accept_sec|see docs|nil|[String, Integer]|
|socket_receive_buffer|see docs|nil|[String, Integer]|
|socket_send_buffer|see docs|nil|[String, Integer]|
|socket_iptos|see docs|nil|[String, Integer]|
|socket_ipttl|see docs|nil|Integer|
|socket_mark|see docs|nil|Integer|
|socket_reuse_port|see docs|nil|[TrueClass, FalseClass]|
|socket_smack_label|see docs|nil|String|
|socket_smack_label_ip_in|see docs|nil|String|
|socket_smack_label_ip_out|see docs|nil|String|
|socket_se_linux_context_from_net|see docs|nil|[TrueClass, FalseClass]|
|socket_pipe_size|see docs|nil|[String, Integer]|
|socket_message_queue_max_messages|see docs|nil|Integer|
|socket_message_queue_message_size|see docs|nil|[String, Integer]|
|socket_free_bind|see docs|nil|[TrueClass, FalseClass]|
|socket_transparent|see docs|nil|[TrueClass, FalseClass]|
|socket_broadcast|see docs|nil|[TrueClass, FalseClass]|
|socket_pass_credentials|see docs|nil|[TrueClass, FalseClass]|
|socket_pass_security|see docs|nil|[TrueClass, FalseClass]|
|socket_tcp_congestion|see docs|nil|String|
|socket_exec_start_pre|see docs|nil|String|
|socket_exec_start_post|see docs|nil|String|
|socket_exec_stop_pre|see docs|nil|String|
|socket_exec_stop_post|see docs|nil|String|
|socket_timeout_sec|see docs|nil|[String, Integer]|
|socket_service|see docs|nil|String|
|socket_remove_on_stop|see docs|nil|[TrueClass, FalseClass]|
|socket_symlinks|see docs|nil|[String, Array]|
|socket_file_descriptor_name|see docs|nil|String|
|socket_trigger_limit_interval_sec|see docs|nil|[String, Integer]|
|socket_trigger_limit_burst|see docs|nil|Integer|
|socket_working_directory|see docs|nil|String|
|socket_root_directory|see docs|nil|String|
|socket_user|see docs|nil|[String, Integer]|
|socket_group|see docs|nil|[String, Integer]|
|socket_supplementary_groups|see docs|nil|[String, Array]|
|socket_nice|see docs|nil|Integer|
|socket_oom_score_adjust|see docs|nil|Integer|
|socket_io_scheduling_class|see docs|nil|[Integer, String]|
|socket_io_scheduling_priority|see docs|nil|Integer|
|socket_cpu_scheduling_policy|see docs|nil|String|
|socket_cpu_scheduling_priority|see docs|nil|Integer|
|socket_cpu_scheduling_reset_on_fork|see docs|nil|[TrueClass, FalseClass]|
|socket_cpu_affinity|see docs|nil|[String, Integer, Array]|
|socket_u_mask|see docs|nil|String|
|socket_environment|see docs|nil|[String, Array, Hash]|
|socket_environment_file|see docs|nil|String|
|socket_pass_environment|see docs|nil|[String, Array]|
|socket_standard_input|see docs|nil|String|
|socket_standard_output|see docs|nil|String|
|socket_standard_error|see docs|nil|String|
|socket_tty_path|see docs|nil|String|
|socket_tty_reset|see docs|nil|[TrueClass, FalseClass]|
|socket_ttyv_hangup|see docs|nil|[TrueClass, FalseClass]|
|socket_ttyvt_disallocate|see docs|nil|[TrueClass, FalseClass]|
|socket_syslog_identifier|see docs|nil|String|
|socket_syslog_facility|see docs|nil|String|
|socket_syslog_level|see docs|nil|String|
|socket_syslog_level_prefix|see docs|nil|[TrueClass, FalseClass]|
|socket_timer_slack_n_sec|see docs|nil|[String, Integer]|
|socket_limit_cpu|see docs|nil|[String, Integer]|
|socket_limit_fsize|see docs|nil|[String, Integer]|
|socket_limit_data|see docs|nil|[String, Integer]|
|socket_limit_stack|see docs|nil|[String, Integer]|
|socket_limit_core|see docs|nil|[String, Integer]|
|socket_limit_rss|see docs|nil|[String, Integer]|
|socket_limit_nofile|see docs|nil|[String, Integer]|
|socket_limit_as|see docs|nil|[String, Integer]|
|socket_limit_nproc|see docs|nil|[String, Integer]|
|socket_limit_memlock|see docs|nil|[String, Integer]|
|socket_limit_locks|see docs|nil|[String, Integer]|
|socket_limit_sigpending|see docs|nil|[String, Integer]|
|socket_limit_msgqueue|see docs|nil|[String, Integer]|
|socket_limit_nice|see docs|nil|[String, Integer]|
|socket_limit_rtprio|see docs|nil|[String, Integer]|
|socket_limit_rttime|see docs|nil|[String, Integer]|
|socket_pam_name|see docs|nil|String|
|socket_capability_bounding_set|see docs|nil|[String, Array]|
|socket_ambient_capabilities|see docs|nil|[String, Array]|
|socket_secure_bits|see docs|nil|[String, Array]|
|socket_read_write_directories|see docs|nil|[String, Array]|
|socket_read_only_directories|see docs|nil|[String, Array]|
|socket_inaccessible_directories|see docs|nil|[String, Array]|
|socket_private_tmp|see docs|nil|[TrueClass, FalseClass]|
|socket_private_devices|see docs|nil|[TrueClass, FalseClass]|
|socket_private_network|see docs|nil|[TrueClass, FalseClass]|
|socket_protect_system|see docs|nil|[TrueClass, FalseClass, String]|
|socket_protect_home|see docs|nil|[TrueClass, FalseClass, String]|
|socket_mount_flags|see docs|nil|String|
|socket_utmp_identifier|see docs|nil|String|
|socket_utmp_mode|see docs|nil|String|
|socket_se_linux_context|see docs|nil|String|
|socket_app_armor_profile|see docs|nil|String|
|socket_smack_process_label|see docs|nil|String|
|socket_ignore_sigpipe|see docs|nil|[TrueClass, FalseClass]|
|socket_no_new_privileges|see docs|nil|[TrueClass, FalseClass]|
|socket_system_call_filter|see docs|nil|[String, Array]|
|socket_system_call_error_number|see docs|nil|String|
|socket_system_call_architectures|see docs|nil|String|
|socket_restrict_address_families|see docs|nil|[String, Array]|
|socket_personality|see docs|nil|String|
|socket_runtime_directory|see docs|nil|[String, Array]|
|socket_runtime_directory_mode|see docs|nil|String|
|socket_kill_mode|see docs|nil|String|
|socket_kill_signal|see docs|nil|[String, Integer]|
|socket_send_sighup|see docs|nil|[TrueClass, FalseClass]|
|socket_send_sigkill|see docs|nil|[TrueClass, FalseClass]|
|socket_cpu_accounting|see docs|nil|[TrueClass, FalseClass]|
|socket_cpu_shares|see docs|nil|Integer|
|socket_startup_cpu_shares|see docs|nil|Integer|
|socket_cpu_quota|see docs|nil|String|
|socket_memory_accounting|see docs|nil|[TrueClass, FalseClass]|
|socket_memory_limit|see docs|nil|[String, Integer]|
|socket_tasks_accounting|see docs|nil|[TrueClass, FalseClass]|
|socket_tasks_max|see docs|nil|[String, Integer]|
|socket_io_accounting|see docs|nil|[TrueClass, FalseClass]|
|socket_io_weight|see docs|nil|Integer|
|socket_startup_io_weight|see docs|nil|Integer|
|socket_io_device_weight|see docs|nil|String|
|socket_io_read_bandwidth_max|see docs|nil|[String, Integer]|
|socket_io_write_bandwidth_max|see docs|nil|[String, Integer]|
|socket_io_read_iops_max|see docs|nil|String|
|socket_io_write_iops_max|see docs|nil|String|
|socket_block_io_accounting|see docs|nil|[TrueClass, FalseClass]|
|socket_block_io_weight|see docs|nil|Integer|
|socket_startup_block_io_weight|see docs|nil|Integer|
|socket_block_io_device_weight|see docs|nil|String|
|socket_block_io_read_bandwidth|see docs|nil|String|
|socket_block_io_write_bandwidth|see docs|nil|String|
|socket_device_allow|see docs|nil|String|
|socket_device_policy|see docs|nil|String|
|socket_slice|see docs|nil|String|
|socket_delegate|see docs|nil|[TrueClass, FalseClass]|
|unit_description|see docs|nil|String|
|unit_documentation|see docs|nil|[String, Array]|
|unit_requires|see docs|nil|[String, Array]|
|unit_requisite|see docs|nil|[String, Array]|
|unit_wants|see docs|nil|[String, Array]|
|unit_binds_to|see docs|nil|[String, Array]|
|unit_part_of|see docs|nil|[String, Array]|
|unit_conflicts|see docs|nil|[String, Array]|
|unit_before|see docs|nil|[String, Array]|
|unit_after|see docs|nil|[String, Array]|
|unit_on_failure|see docs|nil|[String, Array]|
|unit_propagates_reload_to|see docs|nil|[String, Array]|
|unit_reload_propagated_from|see docs|nil|[String, Array]|
|unit_joins_namespace_of|see docs|nil|[String, Array]|
|unit_requires_mounts_for|see docs|nil|[String, Array]|
|unit_on_failure_job_mode|see docs|nil|String|
|unit_ignore_on_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_stop_when_unneeded|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_start|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_stop|see docs|nil|[TrueClass, FalseClass]|
|unit_allow_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_default_dependencies|see docs|nil|[TrueClass, FalseClass]|
|unit_job_timeout_sec|see docs|nil|[String, Integer]|
|unit_job_timeout_action|see docs|nil|String|
|unit_job_timeout_reboot_argument|see docs|nil|String|
|unit_start_limit_interval_sec|see docs|nil|[String, Integer]|
|unit_start_limit_burst|see docs|nil|Integer|
|unit_start_limit_action|see docs|nil|String|
|unit_reboot_argument|see docs|nil|String|
|unit_condition_architecture|see docs|nil|String|
|unit_condition_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_condition_host|see docs|nil|String|
|unit_condition_kernel_command_line|see docs|nil|String|
|unit_condition_security|see docs|nil|String|
|unit_condition_capability|see docs|nil|[String, Array]|
|unit_condition_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_needs_update|see docs|nil|String|
|unit_condition_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_path_exists|see docs|nil|String|
|unit_condition_path_exists_glob|see docs|nil|String|
|unit_condition_path_is_directory|see docs|nil|String|
|unit_condition_path_is_symbolic_link|see docs|nil|String|
|unit_condition_path_is_mount_point|see docs|nil|String|
|unit_condition_path_is_read_write|see docs|nil|String|
|unit_condition_directory_not_empty|see docs|nil|String|
|unit_condition_file_not_empty|see docs|nil|String|
|unit_condition_file_is_executable|see docs|nil|String|
|unit_assert_architecture|see docs|nil|String|
|unit_assert_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_assert_host|see docs|nil|String|
|unit_assert_kernel_command_line|see docs|nil|String|
|unit_assert_security|see docs|nil|String|
|unit_assert_capability|see docs|nil|[String, Array]|
|unit_assert_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_needs_update|see docs|nil|String|
|unit_assert_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_path_exists|see docs|nil|String|
|unit_assert_path_exists_glob|see docs|nil|String|
|unit_assert_path_is_directory|see docs|nil|String|
|unit_assert_path_is_symbolic_link|see docs|nil|String|
|unit_assert_path_is_mount_point|see docs|nil|String|
|unit_assert_path_is_read_write|see docs|nil|String|
|unit_assert_directory_not_empty|see docs|nil|String|
|unit_assert_file_not_empty|see docs|nil|String|
|unit_assert_file_is_executable|see docs|nil|String|
|unit_source_path|see docs|nil|String|
|install_alias|see docs|nil||[String, Array]|
|install_wanted_by|see docs|nil|[String, Array]|
|install_required_by|see docs|nil|[String, Array]|
|install_also|see docs|nil|[String, Array]|
|install_default_instance|see docs|nil|String|
|triggers_reload|see systemd_unit docs|true|[TrueClass, FalseClass]|
|user|see systemd_unit docs|nil|String|
|verify|see systemd_unit docs|true|[TrueClass, FalseClass]|

##### systemd_socket_drop_in

Resource for managing socket unit drop-in files.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

see systemd_socket resource for additional properties.

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|override|name of unit resource is drop-in for|nil|String|
|user|see systemd_unit docs|nil|String|
|drop_in_name|combo of override and resource names, used internally by provider|`lazy { "#{override}-#{name}" }`|String|
|precursor|hash of sections/properties to front-load into configuration|{}|Hash|

##### systemd_swap

Resource for managing [swap units][swap].

###### Actions

Supports all [systemd_unit actions][sd_unit_actions].

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|swap_what|see docs|nil|String|
|swap_priority|see docs|nil|Integer|
|swap_options|see docs|nil|String|
|swap_timeout_sec|see docs|nil|[String, Integer]|
|swap_working_directory|see docs|nil|String|
|swap_root_directory|see docs|nil|String|
|swap_user|see docs|nil|[String, Integer]|
|swap_group|see docs|nil|[String, Integer]|
|swap_supplementary_groups|see docs|nil|[String, Array]|
|swap_nice|see docs|nil|Integer|
|swap_oom_score_adjust|see docs|nil|Integer|
|swap_io_scheduling_class|see docs|nil|[Integer, String]|
|swap_io_scheduling_priority|see docs|nil|Integer|
|swap_cpu_scheduling_policy|see docs|nil|String|
|swap_cpu_scheduling_priority|see docs|nil|Integer|
|swap_cpu_scheduling_reset_on_fork|see docs|nil|[TrueClass, FalseClass]|
|swap_cpu_affinity|see docs|nil|[String, Integer, Array]|
|swap_u_mask|see docs|nil|String|
|swap_environment|see docs|nil|[String, Array, Hash]|
|swap_environment_file|see docs|nil|String|
|swap_pass_environment|see docs|nil|[String, Array]|
|swap_standard_input|see docs|nil|String|
|swap_standard_output|see docs|nil|String|
|swap_standard_error|see docs|nil|String|
|swap_tty_path|see docs|nil|String|
|swap_tty_reset|see docs|nil|[TrueClass, FalseClass]|
|swap_ttyv_hangup|see docs|nil|[TrueClass, FalseClass]|
|swap_ttyvt_disallocate|see docs|nil|[TrueClass, FalseClass]|
|swap_syslog_identifier|see docs|nil|String|
|swap_syslog_facility|see docs|nil|String|
|swap_syslog_level|see docs|nil|String|
|swap_syslog_level_prefix|see docs|nil|[TrueClass, FalseClass]|
|swap_timer_slack_n_sec|see docs|nil|[String, Integer]|
|swap_limit_cpu|see docs|nil|[String, Integer]|
|swap_limit_fsize|see docs|nil|[String, Integer]|
|swap_limit_data|see docs|nil|[String, Integer]|
|swap_limit_stack|see docs|nil|[String, Integer]|
|swap_limit_core|see docs|nil|[String, Integer]|
|swap_limit_rss|see docs|nil|[String, Integer]|
|swap_limit_nofile|see docs|nil|[String, Integer]|
|swap_limit_as|see docs|nil|[String, Integer]|
|swap_limit_nproc|see docs|nil|[String, Integer]|
|swap_limit_memlock|see docs|nil|[String, Integer]|
|swap_limit_locks|see docs|nil|[String, Integer]|
|swap_limit_sigpending|see docs|nil|[String, Integer]|
|swap_limit_msgqueue|see docs|nil|[String, Integer]|
|swap_limit_nice|see docs|nil|[String, Integer]|
|swap_limit_rtprio|see docs|nil|[String, Integer]|
|swap_limit_rttime|see docs|nil|[String, Integer]|
|swap_pam_name|see docs|nil|String|
|swap_capability_bounding_set|see docs|nil|[String, Array]|
|swap_ambient_capabilities|see docs|nil|[String, Array]|
|swap_secure_bits|see docs|nil|[String, Array]|
|swap_read_write_directories|see docs|nil|[String, Array]|
|swap_read_only_directories|see docs|nil|[String, Array]|
|swap_inaccessible_directories|see docs|nil|[String, Array]|
|swap_private_tmp|see docs|nil|[TrueClass, FalseClass]|
|swap_private_devices|see docs|nil|[TrueClass, FalseClass]|
|swap_private_network|see docs|nil|[TrueClass, FalseClass]|
|swap_protect_system|see docs|nil|[TrueClass, FalseClass, String]|
|swap_protect_home|see docs|nil|[TrueClass, FalseClass, String]|
|swap_mount_flags|see docs|nil|String|
|swap_utmp_identifier|see docs|nil|String|
|swap_utmp_mode|see docs|nil|String|
|swap_se_linux_context|see docs|nil|String|
|swap_app_armor_profile|see docs|nil|String|
|swap_smack_process_label|see docs|nil|String|
|swap_ignore_sigpipe|see docs|nil|[TrueClass, FalseClass]|
|swap_no_new_privileges|see docs|nil|[TrueClass, FalseClass]|
|swap_system_call_filter|see docs|nil|[String, Array]|
|swap_system_call_error_number|see docs|nil|String|
|swap_system_call_architectures|see docs|nil|String|
|swap_restrict_address_families|see docs|nil|[String, Array]|
|swap_personality|see docs|nil|String|
|swap_runtime_directory|see docs|nil|[String, Array]|
|swap_runtime_directory_mode|see docs|nil|String|
|swap_kill_mode|see docs|nil|String|
|swap_kill_signal|see docs|nil|[String, Integer]|
|swap_send_sighup|see docs|nil|[TrueClass, FalseClass]|
|swap_send_sigkill|see docs|nil|[TrueClass, FalseClass]|
|swap_cpu_accounting|see docs|nil|[TrueClass, FalseClass]|
|swap_cpu_shares|see docs|nil|Integer|
|swap_startup_cpu_shares|see docs|nil|Integer|
|swap_cpu_quota|see docs|nil|String|
|swap_memory_accounting|see docs|nil|[TrueClass, FalseClass]|
|swap_memory_limit|see docs|nil|[String, Integer]|
|swap_tasks_accounting|see docs|nil|[TrueClass, FalseClass]|
|swap_tasks_max|see docs|nil|[String, Integer]|
|swap_io_accounting|see docs|nil|[TrueClass, FalseClass]|
|swap_io_weight|see docs|nil|Integer|
|swap_startup_io_weight|see docs|nil|Integer|
|swap_io_device_weight|see docs|nil|String|
|swap_io_read_bandwidth_max|see docs|nil|[String, Integer]|
|swap_io_write_bandwidth_max|see docs|nil|[String, Integer]|
|swap_io_read_iops_max|see docs|nil|String|
|swap_io_write_iops_max|see docs|nil|String|
|swap_block_io_accounting|see docs|nil|[TrueClass, FalseClass]|
|swap_block_io_weight|see docs|nil|Integer|
|swap_startup_block_io_weight|see docs|nil|Integer|
|swap_block_io_device_weight|see docs|nil|String|
|swap_block_io_read_bandwidth|see docs|nil|String|
|swap_block_io_write_bandwidth|see docs|nil|String|
|swap_device_allow|see docs|nil|String|
|swap_device_policy|see docs|nil|String|
|swap_slice|see docs|nil|String|
|swap_delegate|see docs|nil|[TrueClass, FalseClass]|
|unit_description|see docs|nil|String|
|unit_documentation|see docs|nil|[String, Array]|
|unit_requires|see docs|nil|[String, Array]|
|unit_requisite|see docs|nil|[String, Array]|
|unit_wants|see docs|nil|[String, Array]|
|unit_binds_to|see docs|nil|[String, Array]|
|unit_part_of|see docs|nil|[String, Array]|
|unit_conflicts|see docs|nil|[String, Array]|
|unit_before|see docs|nil|[String, Array]|
|unit_after|see docs|nil|[String, Array]|
|unit_on_failure|see docs|nil|[String, Array]|
|unit_propagates_reload_to|see docs|nil|[String, Array]|
|unit_reload_propagated_from|see docs|nil|[String, Array]|
|unit_joins_namespace_of|see docs|nil|[String, Array]|
|unit_requires_mounts_for|see docs|nil|[String, Array]|
|unit_on_failure_job_mode|see docs|nil|String|
|unit_ignore_on_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_stop_when_unneeded|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_start|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_stop|see docs|nil|[TrueClass, FalseClass]|
|unit_allow_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_default_dependencies|see docs|nil|[TrueClass, FalseClass]|
|unit_job_timeout_sec|see docs|nil|[String, Integer]|
|unit_job_timeout_action|see docs|nil|String|
|unit_job_timeout_reboot_argument|see docs|nil|String|
|unit_start_limit_interval_sec|see docs|nil|[String, Integer]|
|unit_start_limit_burst|see docs|nil|Integer|
|unit_start_limit_action|see docs|nil|String|
|unit_reboot_argument|see docs|nil|String|
|unit_condition_architecture|see docs|nil|String|
|unit_condition_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_condition_host|see docs|nil|String|
|unit_condition_kernel_command_line|see docs|nil|String|
|unit_condition_security|see docs|nil|String|
|unit_condition_capability|see docs|nil|[String, Array]|
|unit_condition_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_needs_update|see docs|nil|String|
|unit_condition_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_path_exists|see docs|nil|String|
|unit_condition_path_exists_glob|see docs|nil|String|
|unit_condition_path_is_directory|see docs|nil|String|
|unit_condition_path_is_symbolic_link|see docs|nil|String|
|unit_condition_path_is_mount_point|see docs|nil|String|
|unit_condition_path_is_read_write|see docs|nil|String|
|unit_condition_directory_not_empty|see docs|nil|String|
|unit_condition_file_not_empty|see docs|nil|String|
|unit_condition_file_is_executable|see docs|nil|String|
|unit_assert_architecture|see docs|nil|String|
|unit_assert_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_assert_host|see docs|nil|String|
|unit_assert_kernel_command_line|see docs|nil|String|
|unit_assert_security|see docs|nil|String|
|unit_assert_capability|see docs|nil|[String, Array]|
|unit_assert_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_needs_update|see docs|nil|String|
|unit_assert_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_path_exists|see docs|nil|String|
|unit_assert_path_exists_glob|see docs|nil|String|
|unit_assert_path_is_directory|see docs|nil|String|
|unit_assert_path_is_symbolic_link|see docs|nil|String|
|unit_assert_path_is_mount_point|see docs|nil|String|
|unit_assert_path_is_read_write|see docs|nil|String|
|unit_assert_directory_not_empty|see docs|nil|String|
|unit_assert_file_not_empty|see docs|nil|String|
|unit_assert_file_is_executable|see docs|nil|String|
|unit_source_path|see docs|nil|String|
|install_alias|see docs|nil||[String, Array]|
|install_wanted_by|see docs|nil|[String, Array]|
|install_required_by|see docs|nil|[String, Array]|
|install_also|see docs|nil|[String, Array]|
|install_default_instance|see docs|nil|String|
|triggers_reload|see systemd_unit docs|true|[TrueClass, FalseClass]|
|user|see systemd_unit docs|nil|String|
|verify|see systemd_unit docs|true|[TrueClass, FalseClass]|

##### systemd_swap_drop_in

Resource for managing swap unit drop-in files.

###### Actions

Supports `:create` and `:delete` actions.

###### Properties

see systemd_swap resource for additional options.

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|override|name of unit resource is drop-in for|nil|String|
|user|see systemd_unit docs|nil|String|
|drop_in_name|combo of override and resource names, used internally by provider|`lazy { "#{override}-#{name}" }`|String|
|precursor|hash of sections/properties to front-load into configuration|{}|Hash|

##### systemd_target

Resource for managing [target units][target].

###### Actions

Supports all [systemd_unit actions][sd_unit_actions].

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|unit_description|see docs|nil|String|
|unit_documentation|see docs|nil|[String, Array]|
|unit_requires|see docs|nil|[String, Array]|
|unit_requisite|see docs|nil|[String, Array]|
|unit_wants|see docs|nil|[String, Array]|
|unit_binds_to|see docs|nil|[String, Array]|
|unit_part_of|see docs|nil|[String, Array]|
|unit_conflicts|see docs|nil|[String, Array]|
|unit_before|see docs|nil|[String, Array]|
|unit_after|see docs|nil|[String, Array]|
|unit_on_failure|see docs|nil|[String, Array]|
|unit_propagates_reload_to|see docs|nil|[String, Array]|
|unit_reload_propagated_from|see docs|nil|[String, Array]|
|unit_joins_namespace_of|see docs|nil|[String, Array]|
|unit_requires_mounts_for|see docs|nil|[String, Array]|
|unit_on_failure_job_mode|see docs|nil|String|
|unit_ignore_on_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_stop_when_unneeded|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_start|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_stop|see docs|nil|[TrueClass, FalseClass]|
|unit_allow_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_default_dependencies|see docs|nil|[TrueClass, FalseClass]|
|unit_job_timeout_sec|see docs|nil|[String, Integer]|
|unit_job_timeout_action|see docs|nil|String|
|unit_job_timeout_reboot_argument|see docs|nil|String|
|unit_start_limit_interval_sec|see docs|nil|[String, Integer]|
|unit_start_limit_burst|see docs|nil|Integer|
|unit_start_limit_action|see docs|nil|String|
|unit_reboot_argument|see docs|nil|String|
|unit_condition_architecture|see docs|nil|String|
|unit_condition_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_condition_host|see docs|nil|String|
|unit_condition_kernel_command_line|see docs|nil|String|
|unit_condition_security|see docs|nil|String|
|unit_condition_capability|see docs|nil|[String, Array]|
|unit_condition_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_needs_update|see docs|nil|String|
|unit_condition_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_path_exists|see docs|nil|String|
|unit_condition_path_exists_glob|see docs|nil|String|
|unit_condition_path_is_directory|see docs|nil|String|
|unit_condition_path_is_symbolic_link|see docs|nil|String|
|unit_condition_path_is_mount_point|see docs|nil|String|
|unit_condition_path_is_read_write|see docs|nil|String|
|unit_condition_directory_not_empty|see docs|nil|String|
|unit_condition_file_not_empty|see docs|nil|String|
|unit_condition_file_is_executable|see docs|nil|String|
|unit_assert_architecture|see docs|nil|String|
|unit_assert_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_assert_host|see docs|nil|String|
|unit_assert_kernel_command_line|see docs|nil|String|
|unit_assert_security|see docs|nil|String|
|unit_assert_capability|see docs|nil|[String, Array]|
|unit_assert_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_needs_update|see docs|nil|String|
|unit_assert_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_path_exists|see docs|nil|String|
|unit_assert_path_exists_glob|see docs|nil|String|
|unit_assert_path_is_directory|see docs|nil|String|
|unit_assert_path_is_symbolic_link|see docs|nil|String|
|unit_assert_path_is_mount_point|see docs|nil|String|
|unit_assert_path_is_read_write|see docs|nil|String|
|unit_assert_directory_not_empty|see docs|nil|String|
|unit_assert_file_not_empty|see docs|nil|String|
|unit_assert_file_is_executable|see docs|nil|String|
|unit_source_path|see docs|nil|String|
|install_alias|see docs|nil||[String, Array]|
|install_wanted_by|see docs|nil|[String, Array]|
|install_required_by|see docs|nil|[String, Array]|
|install_also|see docs|nil|[String, Array]|
|install_default_instance|see docs|nil|String|
|triggers_reload|see systemd_unit docs|true|[TrueClass, FalseClass]|
|user|see systemd_unit docs|nil|String|
|verify|see systemd_unit docs|true|[TrueClass, FalseClass]|

##### systemd_target_drop_in

Resource for managing target unit drop-in files.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

see systemd_target resource for additional properties.

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|override|name of unit resource is drop-in for|nil|String|
|user|see systemd_unit docs|nil|String|
|drop_in_name|combo of override and resource names, used internally by provider|`lazy { "#{override}-#{name}" }`|String|
|precursor|hash of sections/properties to front-load into configuration|{}|Hash|

##### systemd_timer

Resource for managing [timer units][timer].

###### Actions

Supports all [systemd_unit actions][sd_unit_actions].

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|timer_on_active_sec|see docs|nil|[String, Integer]|
|timer_on_boot_sec|see docs|nil|[String, Integer]|
|timer_on_startup_sec|see docs|nil|[String, Integer]|
|timer_on_unit_active_sec|see docs|nil|[String, Integer]|
|timer_on_unit_inactive_sec|see docs|nil|[String, Integer]|
|timer_on_calendar|see docs|nil|String|
|timer_accuracy_sec|see docs|nil|[String, Integer]|
|timer_randomized_delay_sec|see docs|nil|[String, Integer]|
|timer_unit|see docs|nil|String|
|timer_persistent|see docs|nil|[TrueClass, FalseClass]|
|timer_wake_system|see docs|nil|[TrueClass, FalseClass]|
|timer_remain_after_elapse|see docs|nil|[TrueClass, FalseClass]|
|unit_description|see docs|nil|String|
|unit_documentation|see docs|nil|[String, Array]|
|unit_requires|see docs|nil|[String, Array]|
|unit_requisite|see docs|nil|[String, Array]|
|unit_wants|see docs|nil|[String, Array]|
|unit_binds_to|see docs|nil|[String, Array]|
|unit_part_of|see docs|nil|[String, Array]|
|unit_conflicts|see docs|nil|[String, Array]|
|unit_before|see docs|nil|[String, Array]|
|unit_after|see docs|nil|[String, Array]|
|unit_on_failure|see docs|nil|[String, Array]|
|unit_propagates_reload_to|see docs|nil|[String, Array]|
|unit_reload_propagated_from|see docs|nil|[String, Array]|
|unit_joins_namespace_of|see docs|nil|[String, Array]|
|unit_requires_mounts_for|see docs|nil|[String, Array]|
|unit_on_failure_job_mode|see docs|nil|String|
|unit_ignore_on_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_stop_when_unneeded|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_start|see docs|nil|[TrueClass, FalseClass]|
|unit_refuse_manual_stop|see docs|nil|[TrueClass, FalseClass]|
|unit_allow_isolate|see docs|nil|[TrueClass, FalseClass]|
|unit_default_dependencies|see docs|nil|[TrueClass, FalseClass]|
|unit_job_timeout_sec|see docs|nil|[String, Integer]|
|unit_job_timeout_action|see docs|nil|String|
|unit_job_timeout_reboot_argument|see docs|nil|String|
|unit_start_limit_interval_sec|see docs|nil|[String, Integer]|
|unit_start_limit_burst|see docs|nil|Integer|
|unit_start_limit_action|see docs|nil|String|
|unit_reboot_argument|see docs|nil|String|
|unit_condition_architecture|see docs|nil|String|
|unit_condition_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_condition_host|see docs|nil|String|
|unit_condition_kernel_command_line|see docs|nil|String|
|unit_condition_security|see docs|nil|String|
|unit_condition_capability|see docs|nil|[String, Array]|
|unit_condition_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_needs_update|see docs|nil|String|
|unit_condition_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_condition_path_exists|see docs|nil|String|
|unit_condition_path_exists_glob|see docs|nil|String|
|unit_condition_path_is_directory|see docs|nil|String|
|unit_condition_path_is_symbolic_link|see docs|nil|String|
|unit_condition_path_is_mount_point|see docs|nil|String|
|unit_condition_path_is_read_write|see docs|nil|String|
|unit_condition_directory_not_empty|see docs|nil|String|
|unit_condition_file_not_empty|see docs|nil|String|
|unit_condition_file_is_executable|see docs|nil|String|
|unit_assert_architecture|see docs|nil|String|
|unit_assert_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|unit_assert_host|see docs|nil|String|
|unit_assert_kernel_command_line|see docs|nil|String|
|unit_assert_security|see docs|nil|String|
|unit_assert_capability|see docs|nil|[String, Array]|
|unit_assert_ac_power|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_needs_update|see docs|nil|String|
|unit_assert_first_boot|see docs|nil|[TrueClass, FalseClass]|
|unit_assert_path_exists|see docs|nil|String|
|unit_assert_path_exists_glob|see docs|nil|String|
|unit_assert_path_is_directory|see docs|nil|String|
|unit_assert_path_is_symbolic_link|see docs|nil|String|
|unit_assert_path_is_mount_point|see docs|nil|String|
|unit_assert_path_is_read_write|see docs|nil|String|
|unit_assert_directory_not_empty|see docs|nil|String|
|unit_assert_file_not_empty|see docs|nil|String|
|unit_assert_file_is_executable|see docs|nil|String|
|unit_source_path|see docs|nil|String|
|install_alias|see docs|nil||[String, Array]|
|install_wanted_by|see docs|nil|[String, Array]|
|install_required_by|see docs|nil|[String, Array]|
|install_also|see docs|nil|[String, Array]|
|install_default_instance|see docs|nil|String|
|triggers_reload|see systemd_unit docs|true|[TrueClass, FalseClass]|
|user|see systemd_unit docs|nil|String|
|verify|see systemd_unit docs|true|[TrueClass, FalseClass]|

##### systemd_timer_drop_in

Resource for managing timer unit drop-in files.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

see systemd_timer resource for additional properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|override|name of unit resource is drop-in for|nil|String|
|user|see systemd_unit docs|nil|String|
|drop_in_name|combo of override and resource names, used internally by provider|`lazy { "#{override}-#{name}" }`|String|
|precursor|hash of sections/properties to front-load into configuration|{}|Hash|

#### System Services

|Name|Resource|
|----|--------|
|manager (system)|systemd_system|
|manager (user)|systemd_user|
|journald|systemd_journald|
|logind|systemd_logind|
|resolved|systemd_resolved|
|timesyncd|systemd_timesyncd|

##### systemd_system

Resource for managing systemd [system][system]/session service manager config files.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|manager_log_level|see docs|nil|[String, Integer]|
|manager_log_target|see docs|nil|String|
|manager_log_color|see docs|nil|[TrueClass, FalseClass]|
|manager_log_location|see docs|nil|[TrueClass, FalseClass]|
|manager_dump_core|see docs|nil|[TrueClass, FalseClass]|
|manager_crash_change_vt|see docs|nil|[TrueClass, FalseClass]|
|manager_crash_shell|see docs|nil|[TrueClass, FalseClass]|
|manager_crash_reboot|see docs|nil|[TrueClass, FalseClass]|
|manager_show_status|see docs|nil|[TrueClass, FalseClass]|
|manager_default_standard_output|see docs|nil|String|
|manager_default_standard_error|see docs|nil|String|
|manager_cpu_affinity|see docs|nil|[String, Array]|
|manager_join_controllers|see docs|nil|[String, Array]|
|manager_runtime_watchdog_sec|see docs|nil|[String, Integer]|
|manager_shutdown_watchdog_sec|see docs|nil|[String, Integer]|
|manager_capability_bounding_set|see docs|nil|[String, Array]|
|manager_system_call_architectures|see docs|nil|[String, Array]|
|manager_timer_slack_n_sec|see docs|nil|[String, Integer]|
|manager_default_timer_accuracy_sec|see docs|nil|[String, Integer]|
|manager_default_timeout_start_sec|see docs|nil|[String, Integer]|
|manager_default_timeout_stop_sec|see docs|nil|[String, Integer]|
|manager_default_restart_sec|see docs|nil|[String, Integer]|
|manager_default_start_limit_interval_sec|see docs|nil|[String, Integer]|
|manager_default_start_limit_burst|see docs|nil|Integer|
|manager_default_environment|see docs|nil|[String, Array, Hash]|
|manager_default_cpu_accounting|see docs|nil|[TrueClass, FalseClass]|
|manager_default_block_io_accounting|see docs|nil|[TrueClass, FalseClass]|
|manager_default_memory_accounting|see docs|nil|[TrueClass, FalseClass]|
|manager_default_tasks_accounting|see docs|nil|[TrueClass, FalseClass]|
|manager_default_tasks_max|see docs|nil|[String, Integer]|
|manager_default_limit_cpu|see docs|nil|[String, Integer]|
|manager_default_limit_fsize|see docs|nil|[String, Integer]|
|manager_default_limit_data|see docs|nil|[String, Integer]|
|manager_default_limit_stack|see docs|nil|[String, Integer]|
|manager_default_limit_core|see docs|nil|[String, Integer]|
|manager_default_limit_rss|see docs|nil|[String, Integer]|
|manager_default_limit_nofile|see docs|nil|[String, Integer]|
|manager_default_limit_as|see docs|nil|[String, Integer]|
|manager_default_limit_nproc|see docs|nil|[String, Integer]|
|manager_default_limit_memlock|see docs|nil|[String, Integer]|
|manager_default_limit_locks|see docs|nil|[String, Integer]|
|manager_default_limit_sigpending|see docs|nil|[String, Integer]|
|manager_default_limit_msgqueue|see docs|nil|[String, Integer]|
|manager_default_limit_nice|see docs|nil|[String, Integer]|
|manager_default_limit_rtprio|see docs|nil|[String, Integer]|
|manager_default_limit_rttime|see docs|nil|[String, Integer]|

##### systemd_user

Resource for managing systemd [user][user]/session service manager configuration files.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|manager_log_level|see docs|nil|[String, Integer]|
|manager_log_target|see docs|nil|String|
|manager_log_color|see docs|nil|[TrueClass, FalseClass]|
|manager_log_location|see docs|nil|[TrueClass, FalseClass]|
|manager_dump_core|see docs|nil|[TrueClass, FalseClass]|
|manager_crash_change_vt|see docs|nil|[TrueClass, FalseClass]|
|manager_crash_shell|see docs|nil|[TrueClass, FalseClass]|
|manager_crash_reboot|see docs|nil|[TrueClass, FalseClass]|
|manager_show_status|see docs|nil|[TrueClass, FalseClass]|
|manager_default_standard_output|see docs|nil|String|
|manager_default_standard_error|see docs|nil|String|
|manager_cpu_affinity|see docs|nil|[String, Array]|
|manager_join_controllers|see docs|nil|[String, Array]|
|manager_runtime_watchdog_sec|see docs|nil|[String, Integer]|
|manager_shutdown_watchdog_sec|see docs|nil|[String, Integer]|
|manager_capability_bounding_set|see docs|nil|[String, Array]|
|manager_system_call_architectures|see docs|nil|[String, Array]|
|manager_timer_slack_n_sec|see docs|nil|[String, Integer]|
|manager_default_timer_accuracy_sec|see docs|nil|[String, Integer]|
|manager_default_timeout_start_sec|see docs|nil|[String, Integer]|
|manager_default_timeout_stop_sec|see docs|nil|[String, Integer]|
|manager_default_restart_sec|see docs|nil|[String, Integer]|
|manager_default_start_limit_interval_sec|see docs|nil|[String, Integer]|
|manager_default_start_limit_burst|see docs|nil|Integer|
|manager_default_environment|see docs|nil|[String, Array, Hash]|
|manager_default_cpu_accounting|see docs|nil|[TrueClass, FalseClass]|
|manager_default_block_io_accounting|see docs|nil|[TrueClass, FalseClass]|
|manager_default_memory_accounting|see docs|nil|[TrueClass, FalseClass]|
|manager_default_tasks_accounting|see docs|nil|[TrueClass, FalseClass]|
|manager_default_tasks_max|see docs|nil|[String, Integer]|
|manager_default_limit_cpu|see docs|nil|[String, Integer]|
|manager_default_limit_fsize|see docs|nil|[String, Integer]|
|manager_default_limit_data|see docs|nil|[String, Integer]|
|manager_default_limit_stack|see docs|nil|[String, Integer]|
|manager_default_limit_core|see docs|nil|[String, Integer]|
|manager_default_limit_rss|see docs|nil|[String, Integer]|
|manager_default_limit_nofile|see docs|nil|[String, Integer]|
|manager_default_limit_as|see docs|nil|[String, Integer]|
|manager_default_limit_nproc|see docs|nil|[String, Integer]|
|manager_default_limit_memlock|see docs|nil|[String, Integer]|
|manager_default_limit_locks|see docs|nil|[String, Integer]|
|manager_default_limit_sigpending|see docs|nil|[String, Integer]|
|manager_default_limit_msgqueue|see docs|nil|[String, Integer]|
|manager_default_limit_nice|see docs|nil|[String, Integer]|
|manager_default_limit_rtprio|see docs|nil|[String, Integer]|
|manager_default_limit_rttime|see docs|nil|[String, Integer]|

##### systemd_journald

Resource for managing [systemd-journald][journald] configuration files.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|journal_storage|see docs|nil|String|
|journal_compress|see docs|nil|[TrueClass, FalseClass]|
|journal_seal|see docs|nil|[TrueClass, FalseClass]|
|journal_split_mode|see docs|nil|String|
|journal_rate_limit_interval_sec|see docs|nil|[String, Integer]|
|journal_rate_limit_burst|see docs|nil|Integer|
|journal_system_max_use|see docs|nil|String|
|journal_system_keep_free|see docs|nil|String|
|journal_system_max_file_size|see docs|nil|String|
|journal_system_max_files|see docs|nil|Integer|
|journal_runtime_max_use|see docs|nil|String|
|journal_runtime_keep_free|see docs|nil|String|
|journal_runtime_max_file_size|see docs|nil|String|
|journal_runtime_max_files|see docs|nil|Integer|
|journal_max_file_sec|see docs|nil|[String, Integer]|
|journal_max_retention_sec|see docs|nil|[String, Integer]|
|journal_sync_interval_sec|see docs|nil|[String, Integer]|
|journal_forward_to_syslog|see docs|nil|[TrueClass, FalseClass]|
|journal_forward_to_k_msg|see docs|nil|[TrueClass, FalseClass]|
|journal_forward_to_console|see docs|nil|[TrueClass, FalseClass]|
|journal_max_level_store|see docs|nil|[String, Integer]|
|journal_max_level_syslog|see docs|nil|[String, Integer]|
|journal_max_level_k_msg|see docs|nil|[String, Integer]|
|journal_max_level_console|see docs|nil|[String, Integer]|
|journal_max_level_wall|see docs|nil|[String, Integer]|
|journal_tty_path|see docs|nil|String|

##### systemd_logind

Resource for managing [systemd-logind][logind] configuration files.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|login_n_auto_v_ts|see docs|nil|Integer|
|login_reserve_vt|see docs|nil|Integer|
|login_kill_user_processes|see docs|nil|[TrueClass, FalseClass]|
|login_kill_only_users|see docs|nil|[String, Array]|
|login_kill_exclude_users|see docs|nil|[String, Array]|
|login_idle_action|see docs|nil|String|
|login_idle_action_sec|see docs|nil|[String, Integer]|
|login_inhibit_delay_max_sec|see docs|nil|[String, Integer]|
|login_handle_power_key|see docs|nil|String|
|login_handle_suspend_key|see docs|nil|String|
|login_handle_hibernate_key|see docs|nil|String|
|login_handle_lid_switch|see docs|nil|String|
|login_handle_lid_switch_docked|see docs|nil|String|
|login_power_key_ignore_inhibited|see docs|nil|[TrueClass, FalseClass]|
|login_suspend_key_ignore_inhibited|see docs|nil|[TrueClass, FalseClass]|
|login_hibernate_key_ignore_inhibited|see docs|nil|[TrueClass, FalseClass]|
|login_lid_switch_ignore_inhibited|see docs|nil|[TrueClass, FalseClass]|
|login_holdoff_timeout_sec|see docs|nil|[String, Integer]|
|login_runtime_directory_size|see docs|nil|[String, Integer]|
|login_inhibitors_max|see docs|nil|Integer|
|login_sessions_max|see docs|nil|Integer|
|login_user_tasks_max|see docs|nil|Integer|
|login_remove_ipc|see docs|nil|[TrueClass, FalseClass]|

##### systemd_resolved

Resource for managing [systemd-resolved][resolved] configuration files.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|resolve_dns|see docs|nil|[String, Array]|
|resolve_fallback_dns|see docs|nil|[String, Array]|
|resolve_domains|see docs|nil|[String, Array]|
|resolve_llmnr|see docs|nil|[String, TrueClass, FalseClass]|
|resolve_dnssec|see docs|nil|[String, TrueClass, FalseClass]|

##### systemd_timesyncd

Resource for managing [systemd-timesyncd][timesyncd] configuration files

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|time_ntp|see docs|nil|[String, Array]|
|time_fallback_ntp|see docs|nil|[String, Array]|

#### Utilities

###### Properties

|Name|Resource|
|----|--------|
|binfmt|systemd_binfmt|
|bootchart|systemd_bootchart|
|coredump|systemd_coredump|
|journal-remote|systemd_journal_remote|
|journal-upload|systemd_journal_upload|
|modules|systemd_modules|
|sleep|systemd_sleep|
|sysctl|systemd_sysctl|
|sysuser|systemd_sysuser|
|tmpfile|systemd_tmpfile|

##### systemd_binfmt

Resource for managing binary formats for executables via [systemd-binfmt][binfmt].

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|type|see docs|'M'|String|
|offset|see docs|nil|Integer|
|magic|see docs|nil|String|
|mask|see docs|nil|String|
|interpreter|see docs|nil|String|
|flags|see docs|nil|String|

##### systemd_bootchart

Resource for managing [systemd-bootchart][bootchart].

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|bootchart_samples|see docs|nil|Integer|
|bootchart_frequency|see docs|nil|Numeric|
|bootchart_relative|see docs|nil|[TrueClass, FalseClass]|
|bootchart_filter|see docs|nil|[TrueClass, FalseClass]|
|bootchart_output|see docs|nil|String|
|bootchart_init|see docs|nil|String|
|bootchart_plot_memory_usage|see docs|nil|[TrueClass, FalseClass]|
|bootchart_plot_entropy_graph|see docs|nil|[TrueClass, FalseClass]|
|bootchart_scale_x|see docs|nil|Integer|
|bootchart_scale_y|see docs|nil|Integer|
|bootchart_control_group|see docs|nil|[TrueClass, FalseClass]|

##### systemd_coredump

Resource for managing [systemd-coredump][coredump].

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|coredump_storage|see docs|nil|String|
|coredump_compress|see docs|nil|[TrueClass, FalseClass]|
|coredump_process_size_max|see docs|nil|Integer|
|coredump_external_size_max|see docs|nil|Integer|
|coredump_journal_size_max|see docs|nil|Integer|
|coredump_max_use|see docs|nil|[String, Integer]|
|coredump_keep_free|see docs|nil|[String, Integer]

##### systemd_journal_remote

Resource for configuring [systemd-journal-remote][journal_remote].

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|remote_seal|see docs|nil|[TrueClass, FalseClass]|
|remote_split_mode|see docs|nil|String|
|remote_server_key_file|see docs|nil|String|
|remote_server_certificate_file|see docs|nil|String|
|remote_trusted_certificate_file|see docs|nil|String|

##### systemd_journal_upload

Resource for configuration [systemd-journal-upload][journal_upload].

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|upload_url|see docs|nil|String|
|upload_server_key_file|see docs|nil|String|
|upload_server_certificate_file|see docs|nil|String|
|upload_trusted_certificate_file|see docs|nil|String

##### systemd_modules

Resource for managing kernel modules.

###### Actions

Supports `:create`, `:delete`, `:load`, `:unload` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|blacklist|enabling or blacklisting?|false|[TrueClass, FalseClass|
|modules|array of modules|[]|Array|

##### systemd_sleep

Resource for managing system sleep state logic under [systemd-sleep][sleep].

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|sleep_suspend_mode|see docs|nil|[String, Array]|
|sleep_hibernate_mode|see docs|nil|[String, Array]|
|sleep_hybrid_sleep_mode|see docs|nil|[String, Array]|
|sleep_suspend_state|see docs|nil|[String, Array]|
|sleep_hibernate_state|see docs|nil|[String, Array]|
|sleep_hybrid_sleep_state|see docs|nil|[String, Array]|

##### systemd_sysctl

Resource for managing kernel parameters via [systemd-sysctl][sysctl].

###### Actions

Supports `:create`, `:delete`, & `:apply` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|name|sysctl name|resource name|String|
|value|sysctl value|nil|[String, Numeric, Array]|

##### systemd_sysuser

Resource for managing system users & groups via [systemd-sysuser][sysuser].

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|type|see docs|u|String|
|name|see docs|resource name|String|
|id|see docs|nil|[String, Integer]|
|gecos|see docs|-|String|
|home|see docs|-|String|

##### systemd_tmpfile

Resource for managing temporary files & directories via [systemd-tmpfile][tmpfile].

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|path|see docs|nil|String|
|mode|see docs|-|[String, Numeric]|
|uid|see docs|-|String|
|gid|see docs|-|String|
|age|see docs|-|String|
|argument|see docs|-|String|
|type|see docs|f|String|

#### Machine Management

|Name|Resource|
|----|--------|
|machine|systemd_machine|
|machine_image|systemd_machine_image|
|nspawn|systemd_nspawn|

##### systemd_machine

Resource for managing systemd [machines][machines].

###### Actions

Supports `:start`, `:poweroff`, `:reboot`, `:enable`, `:disable`, `:terminate`, `:kill`, `:copy_to`, `:copy_from` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|signal|see docs|nil|[String,Integer|
|kill_who|see docs|nil|String|
|service|name of service to act on for enable/disable actions|`systemd-nspawn@#{name}.service`|String|
|host_path|used for actions when a path on the host is referenced|nil|String|
|machine_path|used for actions when a path in the machine is referenced|nil|String|

##### systemd_machine_image

Resource for managing [machine images][images].

###### Actions

Supports `:pull`, `:set_properties`, `:clone`, `:rename`, `:remove`, `:import`, `:export` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|type|see docs|tar|String|
|source|source of image|nil|String|
|path|host path for import/export|nil|String|
|size_limit|see docs|nil|String|
|read_only|see docs|false|[TrueClass, FalseClass]|
|from|source name for clone/rename|resource name|String|
|to|destination name for clone/rename|resource name|String|
|force|force for import/export/pull|false|[TrueClass, FalseClass]|
|format|archive format for import/export (see docs for supported options)|nil|String|
|verify|whether to verify on pull|signature|String|

##### systemd_nspawn

Resource for managing machine (container) configuration via [nspawn units][nspawn].

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|exec_boot|see docs|nil|[TrueClass, FalseClass]|
|exec_process_two|see docs|nil|[TrueClass, FalseClass]|
|exec_parameters|see docs|nil|[String, Array]|
|exec_environment|see docs|nil|[String, Array, Hash]|
|exec_user|see docs|nil|String|
|exec_working_directory|see docs|nil|String|
|exec_capability|see docs|nil|[String, Array]|
|exec_drop_capability|see docs|nil|[String, Array]|
|exec_kill_signal|see docs|nil|[String, Integer]|
|exec_personality|see docs|nil|String|
|exec_machine_id|see docs|nil|String|
|exec_private_users|see docs|nil|[TrueClass, FalseClass, String, Integer]|
|exec_notify_ready|see docs|nil|[TrueClass, FalseClass]|
|files_read_only|see docs|nil|[TrueClass, FalseClass]|
|files_volatile|see docs|nil|[TrueClass, FalseClass, String]|
|files_bind|see docs|nil|String|
|files_bind_read_only|see docs|nil|String|
|files_temporary_file_system|see docs|nil|String|
|files_private_users_chown|see docs|nil|[TrueClass, FalseClass]|
|network_private|see docs|nil|[TrueClass, FalseClass]|
|network_virtual_ethernet|see docs|nil|[TrueClass, FalseClass]|
|network_virtual_ethernet_extra|see docs|nil|String|
|network_interface|see docs|nil|[String, Array]|
|network_macvlan|see docs|nil|[String, Array]|
|network_ipvlan|see docs|nil|[String, Array]|
|network_bridge|see docs|nil|String|
|network_zone|see docs|nil|String|
|network_port|see docs|nil|[String, Integer]|

#### Network Configuration

|Name|Resource|
|----|--------|
|network|systemd_network|
|link|systemd_link|
|netdev|systemd_netdev|

##### systemd_network

Resource for managing [network configuration files][network] via systemd-networkd.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|match_mac_address|see docs|nil|String|
|match_path|see docs|nil|[String, Array]|
|match_driver|see docs|nil|[String, Array]|
|match_type|see docs|nil|[String, Array]|
|match_name|see docs|nil|[String, Array]|
|match_host|see docs|nil|String|
|match_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|match_kernel_command_line|see docs|nil|String|
|match_architecture|see docs|nil|String|
|link_mac_address|see docs|nil|String|
|link_mtu_bytes|see docs|nil|[String, Integer]|
|network_description|see docs|nil|String|
|network_dhcp|see docs|nil|[String, Integer, TrueClass, FalseClass]|
|network_dhcp_server|see docs|nil|[TrueClass, FalseClass]|
|network_link_local_addressing|see docs|nil|[String, Integer]|
|network_i_pv4_ll_route|see docs|nil|[TrueClass, FalseClass]|
|network_i_pv6_token|see docs|nil|String|
|network_llmnr|see docs|nil|[String, Integer, TrueClass, FalseClass]|
|network_multicast_dns|see docs|nil|[String, Integer, TrueClass, FalseClass]|
|network_dnssec|see docs|nil|[String, Integer, TrueClass, FalseClass]|
|network_dnssec_negative_trust_anchors|see docs|nil|[String, Array]|
|network_lldp|see docs|nil|[String, Integer, TrueClass, FalseClass]|
|network_emit_lldp|see docs|nil|[TrueClass, FalseClass, String]|
|network_bind_carrier|see docs|nil|[String, Array]|
|network_address|see docs|nil|String|
|network_gateway|see docs|nil|String|
|network_dns|see docs|nil|String|
|network_domains|see docs|nil|[String, Array]|
|network_ntp|see docs|nil|String|
|network_ip_forward|see docs|nil|[TrueClass, FalseClass, String]|
|network_ip_masquerade|see docs|nil|[TrueClass, FalseClass]|
|network_i_pv6_privacy_extensions|see docs|nil|[TrueClass, FalseClass, String]|
|network_i_pv6_accept_ra|see docs|nil|[TrueClass, FalseClass]|
|network_i_pv6_duplicate_address_detection|see docs|nil|Integer|
|network_i_pv6_hop_limit|see docs|nil|Integer|
|network_proxy_arp|see docs|nil|[TrueClass, FalseClass]|
|network_bridge|see docs|nil|String|
|network_bond|see docs|nil|String|
|network_vrf|see docs|nil|String|
|network_vlan|see docs|nil|String|
|network_macvlan|see docs|nil|String|
|network_vxlan|see docs|nil|String|
|network_tunnel|see docs|nil|String|
|address_address|see docs|nil|String|
|address_peer|see docs|nil|String|
|address_broadcast|see docs|nil|String|
|address_label|see docs|nil|String|
|address_preferred_lifetime|see docs|nil|[String, Integer]|
|route_gateway|see docs|nil|String|
|route_destination|see docs|nil|String|
|route_source|see docs|nil|String|
|route_metric|see docs|nil|Integer|
|route_scope|see docs|nil|String|
|route_preferred_source|see docs|nil|String|
|route_table|see docs|nil|Integer|
|dhcp_use_dns|see docs|nil|[TrueClass, FalseClass]|
|dhcp_use_ntp|see docs|nil|[TrueClass, FalseClass]|
|dhcp_use_mtu|see docs|nil|[TrueClass, FalseClass]|
|dhcp_send_hostname|see docs|nil|[TrueClass, FalseClass]|
|dhcp_use_hostame|see docs|nil|[TrueClass, FalseClass]|
|dhcp_hostname|see docs|nil|String|
|dhcp_use_domains|see docs|nil|[TrueClass, FalseClass, String]|
|dhcp_use_routes|see docs|nil|[TrueClass, FalseClass]|
|dhcp_use_timezone|see docs|nil|[TrueClass, FalseClass]|
|dhcp_critical_connection|see docs|nil|[TrueClass, FalseClass]|
|dhcp_client_identifier|see docs|nil|String|
|dhcp_vendor_class_identifier|see docs|nil|String|
|dhcp_duid_type|see docs|nil|String|
|dhcp_duid_raw_data|see docs|nil|String|
|dhcp_iaid|see docs|nil|Integer|
|dhcp_request_broadcast|see docs|nil|[TrueClass, FalseClass]|
|dhcp_route_metric|see docs|nil|Integer|
|i_pv6_accept_ra_use_dns|see docs|nil|[TrueClass, FalseClass]|
|i_pv6_accept_ra_use_domains|see docs|nil|[TrueClass, FalseClass, String]|
|dhcp_server_pool_offset|see docs|nil|String|
|dhcp_server_pool_size|see docs|nil|Integer|
|dhcp_server_default_lease_time_sec|see docs|nil|[String, Integer]|
|dhcp_server_max_lease_time_sec|see docs|nil|[String, Integer]|
|dhcp_server_emit_dns|see docs|nil|[TrueClass, FalseClass]|
|dhcp_server_dns|see docs|nil|[String, Array]|
|dhcp_server_emit_ntp|see docs|nil|[TrueClass, FalseClass]|
|dhcp_server_ntp|see docs|nil|[String, Array]|
|dhcp_server_emit_router|see docs|nil|[TrueClass, FalseClass]|
|dhcp_server_emit_timezone|see docs|nil|[TrueClass, FalseClass]|
|dhcp_server_timezone|see docs|nil|String|
|bridge_unicast_flood|see docs|nil|[TrueClass, FalseClass]|
|bridge_hair_pin|see docs|nil|[TrueClass, FalseClass]|
|bridge_use_bpdu|see docs|nil|[TrueClass, FalseClass]|
|bridge_fast_leave|see docs|nil|[TrueClass, FalseClass]|
|bridge_allow_port_to_be_root|see docs|nil|[TrueClass, FalseClass]|
|bridge_cost|see docs|nil|Integer|
|bridge_fdb_mac_address|see docs|nil|String|
|bridge_fdb_vlan_id|see docs|nil|Integer|
|bridge_vlan_vlan|see docs|nil|Integer|
|bridge_vlan_egress_untagged|see docs|nil|[String, Integer]|
|bridge_vlan_pvid|see docs|nil|Integer|

##### systemd_link

Resource for managing [network device][link] configuration via systemd-networkd.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|match_mac_address|see docs|nil|String|
|match_original_name|see docs|nil|[String, Array]|
|match_path|see docs|nil|[String, Array]|
|match_driver|see docs|nil|[String, Array]|
|match_type|see docs|nil|[String, Array]|
|match_host|see docs|nil|String|
|match_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|match_kernel_command_line|see docs|nil|String|
|match_architecture|see docs|nil|String|
|link_description|see docs|nil|String|
|link_mac_address_policy|see docs|nil|String|
|link_mac_address|see docs|nil|String|
|link_name_policy|see docs|nil|[String, Array]|
|link_name|see docs|nil|String|
|link_mtu_bytes|see docs|nil|[String, Integer]|
|link_bits_per_second|see docs|nil|[String, Integer]|
|link_duplex|see docs|nil|String|
|link_wake_on_lan|see docs|nil|String|

##### systemd_netdev

Resource for managing [virtual network device configuration][netdev] via systemd-networkd.

###### Actions

Supports `:create` & `:delete` actions.

###### Properties

|property|description|default|kind_of|
|--------|-----------|-------|-------|
|match_host|see docs|nil|String|
|match_virtualization|see docs|nil|[String, TrueClass, FalseClass]|
|match_kernel_command_line|see docs|nil|String|
|match_architecture|see docs|nil|String|
|net_dev_description|see docs|nil|String|
|net_dev_name|see docs|nil|String|
|net_dev_kind|see docs|nil|String|
|net_dev_mtu_bytes|see docs|nil|[String, Integer]|
|net_dev_mac_address|see docs|nil|String|
|bridge_hello_time_sec|see docs|nil|[String, Integer]|
|bridge_max_age_sec|see docs|nil|[String, Integer]|
|bridge_forward_delay_sec|see docs|nil|[String, Integer]|
|bridge_multicast_querier|see docs|nil|[TrueClass, FalseClass]|
|bridge_multicast_snooping|see docs|nil|[TrueClass, FalseClass]|
|bridge_vlan_filtering|see docs|nil|[TrueClass, FalseClass]|
|vlan_id|see docs|nil|Integer|
|macvlan_mode|see docs|nil|String|
|macvtap_mode|see docs|nil|String|
|ipvlan_mode|see docs|nil|String|
|vxlan_id|see docs|nil|Integer|
|vxlan_group|see docs|nil|String|
|vxlan_tos|see docs|nil|String|
|vxlan_ttl|see docs|nil|Integer|
|vxlan_mac_learning|see docs|nil|[TrueClass, FalseClass]|
|vxlan_fdb_ageing_sec|see docs|nil|[String, Integer]|
|vxlan_maximum_fdb_entries|see docs|nil|Integer|
|vxlan_arp_proxy|see docs|nil|[TrueClass, FalseClass]|
|vxlan_l2_miss_notification|see docs|nil|[TrueClass, FalseClass]|
|vxlan_l3_miss_notification|see docs|nil|[TrueClass, FalseClass]|
|vxlan_route_short_circuit|see docs|nil|[TrueClass, FalseClass]|
|vxlan_udp_check_sum|see docs|nil|[TrueClass, FalseClass]|
|vxlan_udp6_zero_checksum_tx|see docs|nil|[TrueClass, FalseClass]|
|vxlan_udp6_zero_checksum_rx|see docs|nil|[TrueClass, FalseClass]|
|vxlan_group_policy_extension|see docs|nil|[TrueClass, FalseClass]|
|vxlan_destination_port|see docs|nil|Integer|
|vxlan_port_range|see docs|nil|String|
|tunnel_local|see docs|nil|String|
|tunnel_remote|see docs|nil|String|
|tunnel_tos|see docs|nil|String|
|tunnel_ttl|see docs|nil|String|
|tunnel_discover_path_mtu|see docs|nil|[TrueClass, FalseClass]|
|tunnel_i_pv6_flow_label|see docs|nil|String|
|tunnel_copy_dscp|see docs|nil|[TrueClass, FalseClass]|
|tunnel_encapsulation_limit|see docs|nil|[String, Integer]|
|tunnel_key|see docs|nil|[String, Integer]|
|tunnel_input_key|see docs|nil|[String, Integer]|
|tunnel_output_key|see docs|nil|[String, Integer]|
|tunnel_mode|see docs|nil|String|
|peer_name|see docs|nil|String|
|peer_mac_address|see docs|nil|String|
|tun_one_queue|see docs|nil|[TrueClass, FalseClass]|
|tun_multi_queue|see docs|nil|[TrueClass, FalseClass]|
|tun_packet_info|see docs|nil|[TrueClass, FalseClass]|
|tun_v_net_header|see docs|nil|[TrueClass, FalseClass]|
|tun_user|see docs|nil|String|
|tun_group|see docs|nil|String|
|tap_one_queue|see docs|nil|[TrueClass, FalseClass]|
|tap_multi_queue|see docs|nil|[TrueClass, FalseClass]|
|tap_packet_info|see docs|nil|[TrueClass, FalseClass]|
|tap_v_net_header|see docs|nil|[TrueClass, FalseClass]|
|tap_user|see docs|nil|String|
|tap_group|see docs|nil|String|
|bond_mode|see docs|nil|String|
|bond_transmit_hash_policy|see docs|nil|String|
|bond_lacp_transmit_rate|see docs|nil|String|
|bond_mii_monitor_sec|see docs|nil|[String, Integer]|
|bond_up_delay_sec|see docs|nil|[String, Integer]|
|bond_down_delay_sec|see docs|nil|[String, Integer]|
|bond_learn_packet_interval_sec|see docs|nil|[String, Integer]|
|bond_ad_select|see docs|nil|String|
|bond_fail_over_mac_policy|see docs|nil|String|
|bond_arp_validate|see docs|nil|String|
|bond_arp_interval_sec|see docs|nil|[String, Integer]|
|bond_arpip_targets|see docs|nil|[String, Integer]|
|bond_arp_all_targets|see docs|nil|[String, Array]|
|bond_primary_reselect_policy|see docs|nil|String|
|bond_resend_igmp|see docs|nil|Integer|
|bond_packets_per_slave|see docs|nil|Integer|
|bond_gratuitous_arp|see docs|nil|Integer|
|bond_all_slaves_active|see docs|nil|[TrueClass, FalseClass]|
|bond_min_links|see docs|nil|Integer|

--

[blog]: https://www.freedesktop.org/wiki/Software/systemd#thesystemdforadministratorsblogseries
[chef]: https://chef.io
[docs]: http://www.freedesktop.org/wiki/Software/systemd
[rhel]: https://access.redhat.com/articles/754933
[sd_unit_actions]: https://docs.chef.io/resource_systemd_unit.html#actions
[automount]: https://www.freedesktop.org/software/systemd/man/systemd.automount.html
[mount]: https://www.freedesktop.org/software/systemd/man/systemd.mount.html
[path]: https://www.freedesktop.org/software/systemd/man/systemd.path.html
[service]: https://www.freedesktop.org/software/systemd/man/systemd.service.html
[slice]: https://www.freedesktop.org/software/systemd/man/systemd.slice.html
[socket]: https://www.freedesktop.org/software/systemd/man/systemd.socket.html
[swap]: https://www.freedesktop.org/software/systemd/man/systemd.swap.html
[target]: https://www.freedesktop.org/software/systemd/man/systemd.target.html
[timer]: https://www.freedesktop.org/software/systemd/man/systemd.timer.html
[system]: https://www.freedesktop.org/software/systemd/man/systemd-system.conf.html
[user]: https://www.freedesktop.org/software/systemd/man/systemd-user.conf.html
[journald]: https://www.freedesktop.org/software/systemd/man/systemd-journald.html
[logind]: https://www.freedesktop.org/software/systemd/man/systemd-logind.html
[resolved]: https://www.freedesktop.org/software/systemd/man/systemd-resolved.html
[timesyncd]: https://www.freedesktop.org/software/systemd/man/systemd-timesyncd.html
[binfmt]: https://www.freedesktop.org/software/systemd/man/binfmt.d.html
[bootchart]: http://man7.org/linux/man-pages/man1/systemd-bootchart.1.html
[coredump]: https://www.freedesktop.org/software/systemd/man/systemd-coredump.html
[journal_remote]: https://www.freedesktop.org/software/systemd/man/systemd-journal-remote.html
[journal_upload]: https://www.freedesktop.org/software/systemd/man/systemd-journal-upload.html
[sleep]: https://www.freedesktop.org/software/systemd/man/systemd-sleep.html
[sysctl]: https://www.freedesktop.org/software/systemd/man/systemd-sysctl.service.html
[sysuser]: https://www.freedesktop.org/software/systemd/man/systemd-sysusers.service.html
[tmpfile]: https://www.freedesktop.org/software/systemd/man/systemd-tmpfiles.html
[machines]: https://www.freedesktop.org/software/systemd/man/machinectl.html#Machine%20Commands
[images]: https://www.freedesktop.org/software/systemd/man/machinectl.html#Image%20Commands
[nspawn]: https://www.freedesktop.org/software/systemd/man/systemd.nspawn.html
[network]: https://www.freedesktop.org/software/systemd/man/systemd.network.html
[link]: https://www.freedesktop.org/software/systemd/man/systemd.link.html
[netdev]: https://www.freedesktop.org/software/systemd/man/systemd.netdev.html
