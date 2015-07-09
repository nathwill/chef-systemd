# systemd chef cookbook [![Build Status](https://travis-ci.org/nathwill/chef-systemd.svg?branch=master)][travis]

A resource-drive [Chef][chef] cookbook for [systemd][docs]. Currently under
construction; see issues for list of ways to contribute :)

Cookbook builds on a core systemd_unit resource in order to provide resources
for the following unit types: automount, device, mount, path, service, slice,
socket, swap, target, timer.

Recommended reading:
- This README!
- [Overview of systemd for RHEL 7][rhel]
- [systemd docs][docs]
- [Lennart's blog series][blog]
- libraries under `libraries/*.rb`
- test cookbooks under `test/fixtures/cookbooks/setup`

## Recipes

### systemd::hostnamed

### systemd::journal_gatewayd

### systemd::journald

### systemd::logind

### systemd::machined

### systemd::networkd

### systemd::resolved

### systemd::timedated

### systemd::timesyncd

## Resources

### Foreword

#### Unit basics

[Systemd units][units] are files that describe a system resource, like a
socket, a device, a service, etc. They're written in [INI][ini] format, an
easy and readable format for describing simple configurations.

Admin-generated configurations are stored under '/etc/systemd/system', and
override system-level units located under '/usr/lib/systemd/system'.

Every unit type supports at least a "Unit" and "Install" section. The "Unit"
section carries information about the unit itself, that does not vary between
unit types; attributes like "Requires", "Description", "Conflicts", or
assertions about the unit's expectations about its environment. The "Install"
section carries information about the unit installation, and is only used by
systemd when a unit is enabled or disabled; attributes like "Wants" or "Alias".

Almost every unit unit type (with a couple minor exceptions in device and
target), also support a configuration section based on their own "type". For
example, service units have service-specific configuration in the "Service"
section for configuration options like "ExecStart", and mount units have a
"Mount" section for options like "What", and "Where".

There are also 3 special groups of unit options that are common between several
types of units: exec, kill, and resource-control, which handle common options
re: execution environment configuration (e.g. "WorkingDirectory"), process
killing procedure configuration (e.g. "KillSignal"), and resource control
settings (e.g. "MemoryLimit"). Cookbook resources which support these common
attributes along with their type-specific attributes are explicitly noted in
the resource documentation below, and linked to the documentation for those
attributes.

Hey! That sounds pretty easy, right?

### systemd_automount

Unit which describes a file system automount point controlled by systemd.
[Documentation][automount]

|Attribute|Description|Default|
|---------|-----------|-------|
|where|absolute path of automount directory|nil|
|directory_mode|access mode when creating automount directory|nil|
|timeout_idle_sec|idleness timeout before attempting to unmount|nil|

Also supports: [unit][common_unit], [install][common_install]

### systemd_device

Unit which describes a device as exposed in the sysfs/udev device tree.
[Documentation][device]

This resource has no specific options.

Also supports:
- [unit][common_unit]
- [install][common_install]

### systemd_mount

Unit which describes a file system mount point controlled by systemd.
[Documentation][mount]

|Attribute|Description|Default|
|---------|-----------|-------|
|directory_mode|||
|kill_mode|||
|kill_signal|||
|options|||
|send_sighup|||
|send_sigkill|||
|sloppy_options|||
|timeout_sec|||
|type|||
|what|||
|where|||

Also supports:
- [unit][common_unit]
- [install][common_install]

### systemd_path

Unit which describes information about a path monitored by systemd for
path-based activities.
[Documentation][path]


|Attribute|Description|Default|
|---------|-----------|-------|
|directory_mode|||
|directory_not_empty|||
|make_directory|||
|path_changed|||
|path_exists|||
|path_exists_glob|||
|path_modified|||
|unit|||

Also supports:
- [unit][common_unit]
- [install][common_install]

### systemd_service

Unit which describes information about a process controlled and supervised by systemd.
[Documentation][service]

|Attribute|Description|Default|
|---------|-----------|-------|
|bus_name|||
|bus_policy|||
|exec_reload|||
|exec_start|||
|exec_start_post|||
|exec_start_pre|||
|exec_stop|||
|exec_stop_post|||
|failure_action|||
|file_descriptor_store_max|||
|guess_main_pid|||
|non_blocking|||
|notify_access|||
|permissions_start_only|||
|pid_file|||
|reboot_argument|||
|remain_after_exit|||
|restart|||
|restart_force_exit_status|||
|restart_prevent_exit_status|||
|restart_sec|||
|root_directory_start_only|||
|sockets|||
|start_limit_action|||
|start_limit_burst|||
|start_limit_interval|||
|success_exit_status|||
|timeout_sec|||
|timeout_start_sec|||
|timeout_stop_sec|||
|type|||
|watchdog_sec|||

Also supports:
- [unit][common_unit]
- [install][common_install]

### systemd_slice

Unit which describes a "slice" of the system; useful for managing resources
for of a group of processes.
[Documentation][slice]

This resource has no specific options.

Also supports:
- [unit][common_unit]
- [install][common_install]
- [resource-control][resource_control]

### systemd_socket

Unit which describes an IPC, network socket, or file-system FIFO controlled
and supervised by systemd for socket-based service activation.
[Documentation][socket]

|Attribute|Description|Default|
|---------|-----------|-------|
|accept|||
|backlog|||
|bind_i_pv6_only|||
|bind_to_device|||
|broadcast|||
|defer_accept_sec|||
|directory_mode|||
|exec_start_post|||
|exec_start_pre|||
|exec_stop_post|||
|exec_stop_pre|||
|free_bind|||
|iptos|||
|ipttl|||
|keep_alive|||
|keep_alive_interval_sec|||
|keep_alive_probes|||
|keep_alive_time_sec|||
|listen_datagram|||
|listen_fifo|||
|listen_message_queue|||
|listen_netlink|||
|listen_sequential_packet|||
|listen_special|||
|listen_stream|||
|mark|||
|max_connections|||
|message_queue_max_messages|||
|message_queue_message_size|||
|no_delay|||
|pass_credentials|||
|pass_security|||
|pipe_size|||
|priority|||
|receive_buffer|||
|remove_on_stop|||
|reuse_port|||
|se_linux_context_from_net|||
|send_buffer|||
|service|||
|smack_label|||
|smack_label_ip_in|||
|smack_label_ip_out|||
|socket_group|||
|socket_mode|||
|socket_user|||
|symlinks|||
|tcp_congestion|||
|timeout_sec|||
|transparent|||

Also supports:
- [unit][common_unit]
- [install][common_install]

### systemd_swap

Unit which describes a swap device or file for memory paging.
[Documentation][swap]

|Attribute|Description|Default|
|---------|-----------|-------|
|options|||
|priority|||
|timeout_sec|||
|what|||

Also supports:
- [unit][common_unit]
- [install][common_install]

### systemd_target

Unit which describes a systemd target, used for grouping units and
synchronization points during system start-up.
[Documentation][target]

This unit has no specific options.

Also supports:
- [unit][common_unit]
- [install][common_install]

### systemd_timer

Unit which describes a timer managed by systemd, for timer-based unit
activation (typically a service of the same name).
[Documentation][timer]

|Attribute|Description|Default|
|---------|-----------|-------|
|accuracy_sec|||
|on_active_sec|||
|on_boot_sec|||
|on_calendar|||
|on_startup_sec|||
|on_unit_active_sec|||
|on_unit_inactive_sec|||
|persistent|||
|unit|||
|wake_system|||

Also supports:
- [unit][common_unit]
- [install][common_install]

## Common Attributes

### unit

|Attribute|Description|Default|
|---------|-----------|-------|
|after|||
|allow_isolate|||
|assert_ac_power|||
|assert_architecture|||
|assert_capability|||
|assert_directory_not_empty|||
|assert_file_is_executable|||
|assert_file_not_empty|||
|assert_first_boot|||
|assert_host|||
|assert_kernel_command_line|||
|assert_needs_update|||
|assert_path_exists|||
|assert_path_exists_glob|||
|assert_path_is_directory|||
|assert_path_is_mount_point|||
|assert_path_is_read_write|||
|assert_path_is_symbolic_link|||
|assert_security|||
|assert_virtualization|||
|before|||
|binds_to|||
|condition_ac_power|||
|condition_architecture|||
|condition_capability|||
|condition_directory_not_empty|||
|condition_file_is_executable|||
|condition_file_not_empty|||
|condition_first_boot|||
|condition_host|||
|condition_kernel_command_line|||
|condition_needs_update|||
|condition_path_exists|||
|condition_path_exists_glob|||
|condition_path_is_directory|||
|condition_path_is_mount_point|||
|condition_path_is_read_write|||
|condition_path_is_symbolic_link|||
|condition_security|||
|condition_virtualization|||
|conflicts|||
|default_dependencies|||
|description|||
|documentation|||
|ignore_on_isolate|||
|ignore_on_snapshot|||
|job_timeout_action|||
|job_timeout_reboot_argument|||
|job_timeout_sec|||
|joins_namespace_of|||
|on_failure|||
|on_failure_job_mode|||
|part_of|||
|propagates_reload_to|||
|refuse_manual_start|||
|refuse_manual_stop|||
|reload_propagated_from|||
|requires|||
|requires_mounts_for|||
|requires_overridable|||
|requisite|||
|requisite_overridable|||
|source_path|||
|stop_when_unneeded|||
|wants|||

### install

|Attribute|Description|Default|
|---------|-----------|-------|
|aliases||||
|also|||
|default_instance|||
|required_by|||
|wanted_by|||

### kill

|Attribute|Description|Default|
|---------|-----------|-------|
|kill_mode|||
|kill_signal|||
|send_sighup|||
|send_sigkill|||

### exec

|Attribute|Description|Default|
|---------|-----------|-------|
|app_armor_profile|||
|capabilities|||
|capability_bounding_set|||
|cpu_affinity|||
|cpu_scheduling_policy|||
|cpu_scheduling_priority|||
|cpu_scheduling_reset_on_fork|||
|environment|||
|environment_file|||
|group|||
|ignore_sigpipe|||
|inaccessible_directories|||
|io_scheduling_class|||
|io_scheduling_priority|||
|limit_as|||
|limit_core|||
|limit_cpu|||
|limit_data|||
|limit_fsize|||
|limit_locks|||
|limit_memlock|||
|limit_msgqueue|||
|limit_nice|||
|limit_nofile|||
|limit_nproc|||
|limit_rss|||
|limit_rtprio|||
|limit_rttime|||
|limit_sigpending|||
|limit_stack|||
|mount_flags|||
|nice|||
|no_new_privileges|||
|oom_score_adjust|||
|pam_name|||
|personality|||
|private_devices|||
|private_network|||
|private_tmp|||
|protect_home|||
|protect_system|||
|read_only_directories|||
|read_write_directories|||
|restrict_address_families|||
|root_directory|||
|runtime_directory|||
|runtime_directory_mode|||
|se_linux_context|||
|secure_bits|||
|smack_process_label|||
|standard_error|||
|standard_input|||
|standard_output|||
|supplementary_groups|||
|syslog_facility|||
|syslog_identifier|||
|syslog_level|||
|syslog_level_prefix|||
|system_call_architectures|||
|system_call_error_number|||
|system_call_filter|||
|timer_slack_n_sec|||
|tty_path|||
|tty_reset|||
|ttyv_hangup|||
|ttyvt_disallocate|||
|u_mask|||
|user|||
|utmp_identifier|||
|working_directory|||

### resource-control

|Attribute|Description|Default|
|---------|-----------|-------|
|block_io_accounting|||
|block_io_device_weight|||
|block_io_read_bandwidth|||
|block_io_weight|||
|block_io_write_bandwidth|||
|cpu_accounting|||
|cpu_quota|||
|cpu_shares|||
|delegate|||
|device_allow|||
|device_policy|||
|memory_accounting|||
|memory_limit|||
|slice|||
|startup_block_io_weight|||
|startup_cpu_shares|||

---
[automount]: http://www.freedesktop.org/software/systemd/man/systemd.automount.html
[blog]: http://0pointer.de/blog/projects/systemd-for-admins-1.html
[chef]: https://chef.io
[common_install]: #install
[common_unit]: #unit
[device]: http://www.freedesktop.org/software/systemd/man/systemd.device.html
[docs]: http://www.freedesktop.org/wiki/Software/systemd/
[ini]: https://en.wikipedia.org/wiki/INI_file
[install]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html#%5BInstall%5D%20Section%20Options
[mount]: http://www.freedesktop.org/software/systemd/man/systemd.mount.html
[path]: http://www.freedesktop.org/software/systemd/man/systemd.path.html
[rhel]: https://access.redhat.com/articles/754933
[resource_control]: 
[service]: http://www.freedesktop.org/software/systemd/man/systemd.service.html
[slice]: http://www.freedesktop.org/software/systemd/man/systemd.slice.html
[socket]: http://www.freedesktop.org/software/systemd/man/systemd.socket.html
[swap]: http://www.freedesktop.org/software/systemd/man/systemd.swap.html
[target]: http://www.freedesktop.org/software/systemd/man/systemd.target.html
[timer]: http://www.freedesktop.org/software/systemd/man/systemd.timer.html
[travis]: https://travis-ci.org/nathwill/chef-systemd
[unit]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html#%5BUnit%5D%20Section%20Options
[units]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html
