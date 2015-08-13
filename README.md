# systemd chef cookbook [![Build Status](https://travis-ci.org/nathwill/chef-systemd.svg?branch=master)][travis]

A resource-driven [Chef][chef] cookbook for managing GNU/Linux systems via [systemd][docs].

Currently under active development; early adopters' feedback wanted!

See issues for a list of ways to contribute :)

Recommended reading:
- This README!
- [Overview of systemd for RHEL 7][rhel]
- [systemd docs][docs]
- [Lennart's blog series][blog]
- libraries under `libraries/*.rb`
- test cookbooks under `test/fixtures/cookbooks/setup`

## Recipes

### systemd::bootchart

manages systemd-bootchart via attributes
namespaced under `node['systemd']['bootchart']`.

### systemd::coredump

manages systemd-coredump via attributes
namespaced under `node['systemd']['coredump']`.

### systemd::default

no-op

### systemd::hostname

manages system hostname via `node['systemd']['hostname']` attribute.

### systemd::journald

manages systemd-journald via attributes namespaced
under `node['systemd']['journald']`.

### systemd::journal_gatewayd

manages systemd-journal-gatewayd via attributes
namespaced under `node['systemd']['journal_gatewayd']`.

### systemd::locale

manages system locale via systemd-localed and
attributes namespaced under `node['systemd']['locale']`.

### systemd::logind

manages systemd-logind via attributes namespaced
under `node['systemd']['logind']`.

### systemd::machined

provides a no-op 'systemd-machined' service resource.

### systemd::networkd

enables, starts systemd-networkd daemon

### systemd::resolved

manages systemd-resolved via attributes namespaced
under `node['systemd']['resolved']`.

### systemd::sleep

manages systemd-sleep via attributes namespaced
under `node['systemd']['sleep']`.

### systemd::sysctl

provides a no-op systemd-sysctl service resource.

### systemd::system

manage systemd system-mode defaults via attributes
namespaced under `node['systemd']['system']`.

### systemd::timedated

provides a no-op systemd-timedated resource

### systemd::timesyncd

manages systemd-timesyncd via attributes namespaced
under `node['systemd']['timesyncd']`.

### systemd::udev

manages systemd-udevd via attributes namespaced
under `node['systemd']['udev']`.

### systemd::vconsole

manages system console via systemd-vconsole-setup and
attributes namespaced under `node['systemd']['vconsole']`.

## Resources

### Units

##### systemd_automount

Unit which describes a file system automount point controlled by systemd.
[Documentation][automount]

|Attribute|Description|Default|
|---------|-----------|-------|
|where|see docs|nil|
|directory_mode|see docs|nil|
|timeout_idle_sec|see docs|nil|

Also supports:
- [organization](#organization)
- [unit](#unit)
- [install](#install)
- [drop-in](#drop-in)

##### systemd_device

Unit which describes a device as exposed in the sysfs/udev device tree.
[Documentation][device]

This resource has no specific options.

Also supports:
- [organization](#organization)
- [unit](#unit)
- [install](#install)
- [drop-in](#drop-in)

##### systemd_mount

Unit which describes a file system mount point controlled by systemd.
[Documentation][mount]

|Attribute|Description|Default|
|---------|-----------|-------|
|directory_mode|see docs|nil|
|kill_mode|see docs|nil|
|kill_signal|see docs|nil|
|options|see docs|nil|
|send_sighup|see docs|nil|
|send_sigkill|see docs|nil|
|sloppy_options|see docs|nil|
|timeout_sec|see docs|nil|
|type|see docs|nil|
|what|see docs|nil|
|where|see docs|nil|

Also supports:
- [organization](#organization)
- [unit](#unit)
- [install](#install)
- [drop-in](#drop-in)
- [exec](#exec)
- [kill](#kill)
- [resource-control](#resource-control)

##### systemd_path

Unit which describes information about a path monitored by systemd for
path-based activities.
[Documentation][path]

|Attribute|Description|Default|
|---------|-----------|-------|
|directory_mode|see docs|nil|
|directory_not_empty|see docs|nil|
|make_directory|see docs|nil|
|path_changed|see docs|nil|
|path_exists|see docs|nil|
|path_exists_glob|see docs|nil|
|path_modified|see docs|nil|
|unit|see docs|nil|

Also supports:
- [organization](#organization)
- [unit](#unit)
- [install](#install)
- [drop-in](#drop-in)

##### systemd_service

Unit which describes information about a process controlled and supervised by systemd.
[Documentation][service]

|Attribute|Description|Default|
|---------|-----------|-------|
|bus_name|see docs|nil|
|bus_policy|see docs|nil|
|exec_reload|see docs|nil|
|exec_start|see docs|nil|
|exec_start_post|see docs|nil|
|exec_start_pre|see docs|nil|
|exec_stop|see docs|nil|
|exec_stop_post|see docs|nil|
|failure_action|see docs|nil|
|file_descriptor_store_max|see docs|nil|
|guess_main_pid|see docs|nil|
|non_blocking|see docs|nil|
|notify_access|see docs|nil|
|permissions_start_only|see docs|nil|
|pid_file|see docs|nil|
|reboot_argument|see docs|nil|
|remain_after_exit|see docs|nil|
|restart|see docs|nil|
|restart_force_exit_status|see docs|nil|
|restart_prevent_exit_status|see docs|nil|
|restart_sec|see docs|nil|
|root_directory_start_only|see docs|nil|
|sockets|see docs|nil|
|start_limit_action|see docs|nil|
|start_limit_burst|see docs|nil|
|start_limit_interval|see docs|nil|
|success_exit_status|see docs|nil|
|timeout_sec|see docs|nil|
|timeout_start_sec|see docs|nil|
|timeout_stop_sec|see docs|nil|
|type|see docs|nil|
|watchdog_sec|see docs|nil|

Also supports:
- [organization](#organization)
- [unit](#unit)
- [install](#install)
- [drop-in](#drop-in)
- [exec](#exec)
- [kill](#kill)
- [resource-control](#resource-control)

##### systemd_slice

Unit which describes a "slice" of the system; useful for managing resources
for of a group of processes.
[Documentation][slice]

This resource has no specific options.

Also supports:
- [organization](#organization)
- [unit](#unit)
- [install](#install)
- [drop-in](#drop-in)
- [resource-control](#resource-control)

##### systemd_socket

Unit which describes an IPC, network socket, or file-system FIFO controlled
and supervised by systemd for socket-based service activation.
[Documentation][socket]

|Attribute|Description|Default|
|---------|-----------|-------|
|accept|see docs|nil|
|backlog|see docs|nil|
|bind_i_pv6_only|see docs|nil|
|bind_to_device|see docs|nil|
|broadcast|see docs|nil|
|defer_accept_sec|see docs|nil|
|directory_mode|see docs|nil|
|exec_start_post|see docs|nil|
|exec_start_pre|see docs|nil|
|exec_stop_post|see docs|nil|
|exec_stop_pre|see docs|nil|
|free_bind|see docs|nil|
|iptos|see docs|nil|
|ipttl|see docs|nil|
|keep_alive|see docs|nil|
|keep_alive_interval_sec|see docs|nil|
|keep_alive_probes|see docs|nil|
|keep_alive_time_sec|see docs|nil|
|listen_datagram|see docs|nil|
|listen_fifo|see docs|nil|
|listen_message_queue|see docs|nil|
|listen_netlink|see docs|nil|
|listen_sequential_packet|see docs|nil|
|listen_special|see docs|nil|
|listen_stream|see docs|nil|
|mark|see docs|nil|
|max_connections|see docs|nil|
|message_queue_max_messages|see docs|nil|
|message_queue_message_size|see docs|nil|
|no_delay|see docs|nil|
|pass_credentials|see docs|nil|
|pass_security|see docs|nil|
|pipe_size|see docs|nil|
|priority|see docs|nil|
|receive_buffer|see docs|nil|
|remove_on_stop|see docs|nil|
|reuse_port|see docs|nil|
|se_linux_context_from_net|see docs|nil|
|send_buffer|see docs|nil|
|service|see docs|nil|
|smack_label|see docs|nil|
|smack_label_ip_in|see docs|nil|
|smack_label_ip_out|see docs|nil|
|socket_group|see docs|nil|
|socket_mode|see docs|nil|
|socket_user|see docs|nil|
|symlinks|see docs|nil|
|tcp_congestion|see docs|nil|
|timeout_sec|see docs|nil|
|transparent|see docs|nil|

Also supports:
- [organization](#organization)
- [unit](#unit)
- [install](#install)
- [drop-in](#drop-in)
- [exec](#exec)
- [kill](#kill)
- [resource-control](#resource-control)

##### systemd_swap

Unit which describes a swap device or file for memory paging.
[Documentation][swap]

|Attribute|Description|Default|
|---------|-----------|-------|
|options|see docs|nil|
|priority|see docs|nil|
|timeout_sec|see docs|nil|
|what|see docs|nil|

Also supports:
- [organization](#organization)
- [unit](#unit)
- [install](#install)
- [drop-in](#drop-in)
- [exec](#exec)
- [kill](#kill)
- [resource-control](#resource-control)

##### systemd_target

Unit which describes a systemd target, used for grouping units and
synchronization points during system start-up.
[Documentation][target]

This unit has no specific options.

Also supports:
- [organization](#organization)
- [unit](#unit)
- [install](#install)
- [drop-in](#drop-in)

##### systemd_timer

Unit which describes a timer managed by systemd, for timer-based unit
activation (typically a service of the same name).
[Documentation][timer]

|Attribute|Description|Default|
|---------|-----------|-------|
|accuracy_sec|see docs|nil|
|on_active_sec|see docs|nil|
|on_boot_sec|see docs|nil|
|on_calendar|see docs|nil|
|on_startup_sec|see docs|nil|
|on_unit_active_sec|see docs|nil|
|on_unit_inactive_sec|see docs|nil|
|persistent|see docs|nil|
|unit|see docs|nil|
|wake_system|see docs|nil|

Also supports:
- [organization](#organization)
- [unit](#unit)
- [install](#install)
- [drop-in](#drop-in)

#### Common Unit Attributes

##### organization

special no-op attributes that yield to a block for the purpose of being
able to group attributes of a resource similar to their rendered grouping.

|Attribute|Description|Default|
|---------|-----------|-------|
|install|no-op block yielder|nil|
|$unit_type|no-op block yielder|nil|

By way of explanation:

```ruby
systemd_automount 'vagrant-home' do
  description 'Test Automount'
  install do
    wanted_by 'local-fs.target'
  end
  automount do
    where '/home/vagrant'
  end
end
```

##### unit

Common configuration options of all the unit types.
[Documentation][unit]

|Attribute|Description|Default|
|---------|-----------|-------|
|after|see docs|nil|
|allow_isolate|see docs|nil|
|assert_ac_power|see docs|nil|
|assert_architecture|see docs|nil|
|assert_capability|see docs|nil|
|assert_directory_not_empty|see docs|nil|
|assert_file_is_executable|see docs|nil|
|assert_file_not_empty|see docs|nil|
|assert_first_boot|see docs|nil|
|assert_host|see docs|nil|
|assert_kernel_command_line|see docs|nil|
|assert_needs_update|see docs|nil|
|assert_path_exists|see docs|nil|
|assert_path_exists_glob|see docs|nil|
|assert_path_is_directory|see docs|nil|
|assert_path_is_mount_point|see docs|nil|
|assert_path_is_read_write|see docs|nil|
|assert_path_is_symbolic_link|see docs|nil|
|assert_security|see docs|nil|
|assert_virtualization|see docs|nil|
|before|see docs|nil|
|binds_to|see docs|nil|
|condition_ac_power|see docs|nil|
|condition_architecture|see docs|nil|
|condition_capability|see docs|nil|
|condition_directory_not_empty|see docs|nil|
|condition_file_is_executable|see docs|nil|
|condition_file_not_empty|see docs|nil|
|condition_first_boot|see docs|nil|
|condition_host|see docs|nil|
|condition_kernel_command_line|see docs|nil|
|condition_needs_update|see docs|nil|
|condition_path_exists|see docs|nil|
|condition_path_exists_glob|see docs|nil|
|condition_path_is_directory|see docs|nil|
|condition_path_is_mount_point|see docs|nil|
|condition_path_is_read_write|see docs|nil|
|condition_path_is_symbolic_link|see docs|nil|
|condition_security|see docs|nil|
|condition_virtualization|see docs|nil|
|conflicts|see docs|nil|
|default_dependencies|see docs|nil|
|description|see docs|nil|
|documentation|see docs|nil|
|ignore_on_isolate|see docs|nil|
|ignore_on_snapshot|see docs|nil|
|job_timeout_action|see docs|nil|
|job_timeout_reboot_argument|see docs|nil|
|job_timeout_sec|see docs|nil|
|joins_namespace_of|see docs|nil|
|on_failure|see docs|nil|
|on_failure_job_mode|see docs|nil|
|part_of|see docs|nil|
|propagates_reload_to|see docs|nil|
|refuse_manual_start|see docs|nil|
|refuse_manual_stop|see docs|nil|
|reload_propagated_from|see docs|nil|
|requires|see docs|nil|
|requires_mounts_for|see docs|nil|
|requires_overridable|see docs|nil|
|requisite|see docs|nil|
|requisite_overridable|see docs|nil|
|source_path|see docs|nil|
|stop_when_unneeded|see docs|nil|
|wants|see docs|nil|

##### install

Carries installation information for units. Used exclusively by
enable/disable commands of `systemctl`. [Documentation][install]

|Attribute|Description|Default|
|---------|-----------|-------|
|aliases|array of aliases|[]|
|also|see docs|nil|
|default_instance|see docs|nil|
|required_by|see docs|nil|
|wanted_by|see docs|nil|

##### drop-in

Cookbook-specific attributes that activate and control drop-in mode for units.

|Attribute|Description|Default|
|---------|-----------|-------|
|drop_in|boolean which sets if resource is a drop-in unit|false|
|override|which unit to override, prefix only. suffix determined by resource unit type (e.g. "ssh" on a systemd_service -> "ssh.service.d")|nil|
|overrides|drop-in unit options that require a reset (e.g. "ExecStart" -> "ExecStart=" at top of section)|[]|

##### kill

Process killing procedure configuration. [Documentation][kill]

|Attribute|Description|Default|
|---------|-----------|-------|
|kill_mode|see docs|nil|
|kill_signal|see docs|nil|
|send_sighup|see docs|nil|
|send_sigkill|see docs|nil|

##### exec

Execution environment configuration. [Documentation][exec]

|Attribute|Description|Default|
|---------|-----------|-------|
|app_armor_profile|see docs|nil|
|capabilities|see docs|nil|
|capability_bounding_set|see docs|nil|
|cpu_affinity|see docs|nil|
|cpu_scheduling_policy|see docs|nil|
|cpu_scheduling_priority|see docs|nil|
|cpu_scheduling_reset_on_fork|see docs|nil|
|environment|see docs|nil|
|environment_file|see docs|nil|
|group|see docs|nil|
|ignore_sigpipe|see docs|nil|
|inaccessible_directories|see docs|nil|
|io_scheduling_class|see docs|nil|
|io_scheduling_priority|see docs|nil|
|limit_as|see docs|nil|
|limit_core|see docs|nil|
|limit_cpu|see docs|nil|
|limit_data|see docs|nil|
|limit_fsize|see docs|nil|
|limit_locks|see docs|nil|
|limit_memlock|see docs|nil|
|limit_msgqueue|see docs|nil|
|limit_nice|see docs|nil|
|limit_nofile|see docs|nil|
|limit_nproc|see docs|nil|
|limit_rss|see docs|nil|
|limit_rtprio|see docs|nil|
|limit_rttime|see docs|nil|
|limit_sigpending|see docs|nil|
|limit_stack|see docs|nil|
|mount_flags|see docs|nil|
|nice|see docs|nil|
|no_new_privileges|see docs|nil|
|oom_score_adjust|see docs|nil|
|pam_name|see docs|nil|
|personality|see docs|nil|
|private_devices|see docs|nil|
|private_network|see docs|nil|
|private_tmp|see docs|nil|
|protect_home|see docs|nil|
|protect_system|see docs|nil|
|read_only_directories|see docs|nil|
|read_write_directories|see docs|nil|
|restrict_address_families|see docs|nil|
|root_directory|see docs|nil|
|runtime_directory|see docs|nil|
|runtime_directory_mode|see docs|nil|
|se_linux_context|see docs|nil|
|secure_bits|see docs|nil|
|smack_process_label|see docs|nil|
|standard_error|see docs|nil|
|standard_input|see docs|nil|
|standard_output|see docs|nil|
|supplementary_groups|see docs|nil|
|syslog_facility|see docs|nil|
|syslog_identifier|see docs|nil|
|syslog_level|see docs|nil|
|syslog_level_prefix|see docs|nil|
|system_call_architectures|see docs|nil|
|system_call_error_number|see docs|nil|
|system_call_filter|see docs|nil|
|timer_slack_n_sec|see docs|nil|
|tty_path|see docs|nil|
|tty_reset|see docs|nil|
|ttyv_hangup|see docs|nil|
|ttyvt_disallocate|see docs|nil|
|u_mask|see docs|nil|
|user|see docs|nil|
|utmp_identifier|see docs|nil|
|working_directory|see docs|nil|

##### resource-control

Resource control unit settings. [Documentation][resource_control]

|Attribute|Description|Default|
|---------|-----------|-------|
|block_io_accounting|see docs|nil|
|block_io_device_weight|see docs|nil|
|block_io_read_bandwidth|see docs|nil|
|block_io_weight|see docs|nil|
|block_io_write_bandwidth|see docs|nil|
|cpu_accounting|see docs|nil|
|cpu_quota|see docs|nil|
|cpu_shares|see docs|nil|
|delegate|see docs|nil|
|device_allow|see docs|nil|
|device_policy|see docs|nil|
|memory_accounting|see docs|nil|
|memory_limit|see docs|nil|
|slice|see docs|nil|
|startup_block_io_weight|see docs|nil|
|startup_cpu_shares|see docs|nil|

### Daemons

##### systemd_journald

resource for managing [systemd-journald][journald] configuration.

|Attribute|Description|Default|
|---------|-----------|-------|
|drop_in|boolean which sets if resource is a drop-in unit|true|
|storage|see docs|nil|
|compress|see docs|nil|
|seal|see docs|nil|
|split_mode|see docs|nil|
|rate_limit_interval|see docs|nil|
|rate_limit_burst|see docs|nil|
|system_max_use|see docs|nil|
|system_keep_free|see docs|nil|
|system_max_file_size|see docs|nil|
|runtime_max_use|see docs|nil|
|runtime_keep_free|see docs|nil|
|runtime_max_file_size|see docs|nil|
|max_file_sec|see docs|nil|
|max_retention_sec|see docs|nil|
|sync_interval_sec|see docs|nil|
|forward_to_syslog|see docs|nil|
|forward_to_k_msg|see docs|nil|
|forward_to_console|see docs|nil|
|forward_to_wall|see docs|nil|
|max_level_store|see docs|nil|
|max_level_syslog|see docs|nil|
|max_level_k_msg|see docs|nil|
|max_level_console|see docs|nil|
|max_level_wall|see docs|nil|
|tty_path|see docs|nil|


##### systemd_logind

resource for managing [systemd-logind][logind] configuration.

|Attribute|Description|Default|
|---------|-----------|-------|
|drop_in|boolean which sets if resource is a drop-in unit|true|
|n_auto_v_ts|see docs|nil|
|reserve_vt|see docs|nil|
|kill_user_processes|see docs|nil|
|kill_only_users|see docs|nil|
|kill_exclude_users|see docs|nil|
|idle_action|see docs|nil|
|idle_action_sec|see docs|nil|
|inhibit_delay_max_sec|see docs|nil|
|handle_power_key|see docs|nil|
|handle_suspend_key|see docs|nil|
|handle_hibernate_key|see docs|nil|
|handle_lid_switch|see docs|nil|
|handle_lid_switch_docked|see docs|nil|
|power_key_ignore_inhibited|see docs|nil|
|suspend_key_ignore_inhibited|see docs|nil|
|hibernate_key_ignore_inhibited|see docs|nil|
|lid_switch_ignore_inhibited|see docs|nil|
|holdoff_timeout_sec|see docs|nil|
|runtime_directory_size|see docs|nil|
|remove_ipc|see docs|nil|

##### systemd_resolved

resource for managing [systemd-resolved][resolved] configuration.

|Attribute|Description|Default|
|---------|-----------|-------|
|drop_in|boolean which sets if resource is a drop-in unit|true|
|dns|see docs|nil|
|fallback_dns|see docs|nil|
|llmnr|see docs|nil|

##### systemd_timesyncd

resource for managing [systemd-timesyncd][timesyncd] configuration.

|Attribute|Description|Default|
|---------|-----------|-------|
|drop_in|boolean which sets if resource is a drop-in unit|true|
|ntp|see docs|nil|
|fallback_ntp|see docs|nil|

### Utilities

##### systemd_bootchart

Configure [systemd-bootchart][bootchart].

|Attribute|Description|Default|
|---------|-----------|-------|
|drop_in|boolean which sets if resource is a drop-in unit|true|
|samples|see docs|nil|
|frequency|see docs|nil|
|relative|see docs|nil|
|filter|see docs|nil|
|output|see docs|nil|
|init|see docs|nil|
|plot_memory_usage|see docs|nil|
|plot_entropy_graph|see docs|nil|
|scale_x|see docs|nil|
|scale_y|see docs|nil|
|control_group|see docs|nil|

##### systemd_coredump

Configure [systemd-coredump][coredump].

|Attribute|Description|Default|
|---------|-----------|-------|
|drop_in|boolean which sets if resource is a drop-in unit|true|
|storage|see docs|nil|
|compress|see docs|nil|
|process_size_max|see docs|nil|
|external_size_max|see docs|nil|
|journal_size_max|see docs|nil|
|max_use|see docs|nil|
|keep_free|see docs|nil|

##### systemd_sleep

Configure [systemd-sleep][sleep].

|Attribute|Description|Default|
|---------|-----------|-------|
|drop_in|boolean which sets if resource is a drop-in unit|true|
|suspend_mode|see docs|nil|
|hibernate_mode|see docs|nil|
|hybrid_sleep_mode|see docs|nil|
|suspend_state|see docs|nil|
|hibernate_state|see docs|nil|
|hybrid_sleep_state|see docs|nil|

##### systemd_system

Configure systemd [system-mode][system] defaults.

|Attribute|Description|Default|
|---------|-----------|-------|
|drop_in|boolean which sets if resource is a drop-in unit|true|
|log_level|see docs|nil|
|log_target|see docs|nil|
|log_color|see docs|nil|
|log_location|see docs|nil|
|dump_core|see docs|nil|
|crash_shell|see docs|nil|
|show_status|see docs|nil|
|crash_ch_vt|see docs|nil|
|default_standard_output|see docs|nil|
|default_standard_error|see docs|nil|
|cpu_affinity|see docs|nil|
|join_controllers|see docs|nil|
|runtime_watchdog_sec|see docs|nil|
|shutdown_watchdog_sec|see docs|nil|
|capability_bounding_set|see docs|nil|
|system_call_architectures|see docs|nil|
|timer_slack_n_sec|see docs|nil|
|default_timer_accuracy_sec|see docs|nil|
|default_timeout_start_sec|see docs|nil|
|default_timeout_stop_sec|see docs|nil|
|default_restart_sec|see docs|nil|
|default_start_limit_interval|see docs|nil|
|default_start_limit_burst|see docs|nil|
|default_environment|see docs|nil|
|default_cpu_accounting|see docs|nil|
|default_block_io_accounting|see docs|nil|
|default_memory_accounting|see docs|nil|
|default_limit_cpu|see docs|nil|
|default_limit_fsize|see docs|nil|
|default_limit_data|see docs|nil|
|default_limit_stack|see docs|nil|
|default_limit_core|see docs|nil|
|default_limit_rss|see docs|nil|
|default_limit_nofile|see docs|nil|
|default_limit_as|see docs|nil|
|default_limit_nproc|see docs|nil|
|default_limit_memlock|see docs|nil|
|default_limit_locks|see docs|nil|
|default_limit_sigpending|see docs|nil|
|default_limit_msgqueue|see docs|nil|
|default_limit_nice|see docs|nil|
|default_limit_rtprio|see docs|nil|
|default_limit_rttime|see docs|nil|

##### systemd_user

Configure systemd [user-mode][system] defaults.

Has same attributes as systemd_user.

### Misc

##### systemd_networkd_link

Configure network links via [systemd-networkd][networkd] link files.

|Attribute|Description|Default|
|---------|-----------|-------|
|link_mac_address|set Link section MACAddress option. see docs.|nil|
|match_mac_address|set Match section MACAddress option. see docs.|nil|
|original_name|see docs|nil|
|path|see docs|nil|
|driver|see docs|nil|
|type|see docs|nil|
|host|see docs|nil|
|virtualization|see docs|nil|
|kernel_command_line|see docs|nil|
|architecture|see docs|nil|
|description|see docs|nil|
|link_alias|set link section Alias option. see docs.|nil|
|mac_address_policy|see docs|nil|
|name_policy|see docs|nil|
|name|see docs|nil|
|mtu_bytes|see docs|nil|
|bits_per_second|see docs|nil|
|duplex|see docs|nil|
|wake_on_lan|see docs|nil|

##### systemd_sysctl

Configure sysctl settings via [systemd-sysctl][sysctl] sysctl.d.

|Attribute|Description|Default|
|---------|-----------|-------|
|name|sysctl name|resource name|
|value|sysctl value|nil|

##### systemd_tmpfile

Configure system temporary files via [systemd-tmpfiles][tmpfiles] tmpfiles.d.

|Attribute|Description|Default|
|---------|-----------|-------|
|path|path config for tmpfiles|nil|
|mode|mode config for tmpfiles|"-"|
|uid|uid config for tmpfiles|"-"|
|gid|gid config for tmpfiles|"-"|
|age|age config for tmpfiles|"-"|
|argument|argument config for tmpfiles|"-"|
|type|type config for tmpfiles|"f"|

---
[automount]: http://www.freedesktop.org/software/systemd/man/systemd.automount.html
[blog]: http://0pointer.de/blog/projects/systemd-for-admins-1.html
[bootchart]: http://www.freedesktop.org/software/systemd/man/systemd-bootchart.html
[chef]: https://chef.io
[coredump]: http://www.freedesktop.org/software/systemd/man/systemd-coredump.html
[device]: http://www.freedesktop.org/software/systemd/man/systemd.device.html
[docs]: http://www.freedesktop.org/wiki/Software/systemd/
[exec]: http://www.freedesktop.org/software/systemd/man/systemd.exec.html
[ini]: https://en.wikipedia.org/wiki/INI_file
[install]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html#%5BInstall%5D%20Section%20Options
[journald]: www.freedesktop.org/software/systemd/man/systemd-journald.html
[kill]: http://www.freedesktop.org/software/systemd/man/systemd.kill.html
[logind]: www.freedesktop.org/software/systemd/man/systemd-logind.html
[mount]: http://www.freedesktop.org/software/systemd/man/systemd.mount.html
[networkd]: http://www.freedesktop.org/software/systemd/man/systemd-networkd.service.html
[path]: http://www.freedesktop.org/software/systemd/man/systemd.path.html
[resolved]: www.freedesktop.org/software/systemd/man/systemd-resolved.html
[rhel]: https://access.redhat.com/articles/754933
[resource_control]: http://www.freedesktop.org/software/systemd/man/systemd.resource-control.html
[service]: http://www.freedesktop.org/software/systemd/man/systemd.service.html
[sleep]: http://www.freedesktop.org/software/systemd/man/systemd-sleep.conf.html
[slice]: http://www.freedesktop.org/software/systemd/man/systemd.slice.html
[socket]: http://www.freedesktop.org/software/systemd/man/systemd.socket.html
[swap]: http://www.freedesktop.org/software/systemd/man/systemd.swap.html
[sysctl]: http://www.freedesktop.org/software/systemd/man/systemd-sysctl.html
[system]: http://www.freedesktop.org/software/systemd/man/systemd-system.conf.html
[target]: http://www.freedesktop.org/software/systemd/man/systemd.target.html
[timer]: http://www.freedesktop.org/software/systemd/man/systemd.timer.html
[timesyncd]: www.freedesktop.org/software/systemd/man/systemd-timesyncd.html
[tmpfiles]: http://www.freedesktop.org/software/systemd/man/systemd-tmpfiles.html
[travis]: https://travis-ci.org/nathwill/chef-systemd
[unit]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html#%5BUnit%5D%20Section%20Options
[units]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html
