Systemd Chef Cookbook
=====================

[![Cookbook](http://img.shields.io/cookbook/v/systemd.svg)](https://github.com/nathwill/chef-systemd)
[![Build Status](https://travis-ci.org/nathwill/chef-systemd.svg?branch=master)](https://travis-ci.org/nathwill/chef-systemd)

A resource-driven [Chef][chef] cookbook for managing GNU/Linux systems via [systemd][docs].

<a name="toc">Table of Contents</a>
===================================

 - [Recommended Reading](#recommended-reading)
 - [Attributes](#attributes)
 - [Recipes](#recipes)
   - [Daemons](#daemon-recipes)
   - [Utilities](#utility-recipes)
 - [Resources](#resources)
   - [Daemons](#daemon-resources)
   - [Utilities](#utility-resources)
   - [Common Attributes](#common-resource-attributes)
     - [Exec](#common-exec)
     - [Kill](#common-kill)
     - [Resource Control](#common-resource-control)
     - [Unit](#common-unit)
     - [Install](#common-install)
     - [Drop-In](#common-drop-in)

<a name="recommended-reading">Recommended Reading</a>
=====================================================

 - This README
 - [Overview of systemd for RHEL 7][rhel]
 - [systemd docs][docs]
 - [Lennart's blog series][blog]
 - libraries in `libraries/*.rb`
 - test cookbook in `test/fixtures/cookbooks/setup`

<a name="attributes">Attributes</a>
===================================

too many to describe in detail ;).
in general, the attributes correspond to the related resource attributes.

<a name="recipes">Recipes</a>
=============================

 - **default**: no-op recipe

<a name="daemon-recipes">Daemon Recipes</a>
-------------------------------------------

 - **journald**: configure, manage systemd-journald
 - **journal\_gatewayd**: configure, manage systemd-journal-gatewayd
 - **logind**: configure, manage systemd-logind
 - **machined**: manage systemd-machined service
 - **networkd**: manage systemd-networkd service
 - **resolved**: configure, manage systemd-resolved
 - **timesyncd**: configure, manage systemd-timesyncd
 - **udevd**: configure, manage systemd-udevd

<a name="utility-recipes">Utility Recipes</a>
---------------------------------------------

 - **binfmt**: manage systemd-binfmt one-shot boot-up unit
 - **bootchart**: configure systemd-bootchart
 - **coredump**: configure systemd-coredump
 - **hostname**: configure, manage hostname with systemd-hostnamed
 - **locale**: configure, manage locale with systemd-localed
 - **real\_time\_clock**: configure system clock mode (UTC,local) with timedatectl
 - **sleep**: configure system sleep, suspend, hibernate behavior with systemd-sleep
 - **sysctl**: manage systemd-sysctl one-shot boot-up unit (apply sysctl at boot)
 - **system**: configure systemd manager system-mode defaults
 - **sysusers**: manage systemd-sysusers one-shot boot-up unit (set up system users at boot)
 - **timedated**: manage systemd-timedated one-shot boot-up unit (set time/date at boot)
 - **timezone**: configure, manage timezone with timedatectl
 - **user**: configure systemd manager user-mode defaults
 - **vconsole**: configure, manage virtual console font and keymap with systemd-vconsole

<a name="resources"></a>Resources
=================================

<a name="unit-resources"></a>Unit Resources
-------------------------------------------

<a name="systemd-automount"></a>**systemd\_automount**

Unit which describes a file system automount point controlled by systemd.
[Documentation][automount]

|Attribute|Description|Default|
|---------|-----------|-------|
|where|see docs|nil|
|directory_mode|see docs|nil|
|timeout_idle_sec|see docs|nil|

Also supports:

 - [organization](#organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)

<a name="systemd-device"></a>**systemd\_device**

Unit which describes a device as exposed in the sysfs/udev device tree.
[Documentation][device]

This resource has no specific options.

Also supports:

 - [organization](#common-organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)

<a name="systemd-mount"></a>**systemd\_mount**

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

 - [organization](#common-organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)
 - [exec](#common-exec)
 - [kill](#common-kill)
 - [resource-control](#common-resource-control)

<a name="systemd-path"></a>**systemd\_path**

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

 - [organization](#common-organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)

<a name="systemd-service"></a>**systemd\_service**

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

 - [organization](#common-organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)
 - [exec](#common-exec)
 - [kill](#common-kill)
 - [resource-control](#common-resource-control)

<a name="systemd-slice"></a>**systemd\_slice**

Unit which describes a "slice" of the system; useful for managing resources
for of a group of processes.
[Documentation][slice]

This resource has no specific options.

Also supports:

 - [organization](#common-organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)
 - [resource-control](#common-resource-control)

<a name="systemd-socket"></a>**systemd\_socket**

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

 - [organization](#common-organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)
 - [exec](#common-exec)
 - [kill](#common-kill)
 - [resource-control](#common-resource-control)

<a name="systemd-swap"></a>**systemd\_swap**

Unit which describes a swap device or file for memory paging.
[Documentation][swap]

|Attribute|Description|Default|
|---------|-----------|-------|
|options|see docs|nil|
|priority|see docs|nil|
|timeout_sec|see docs|nil|
|what|see docs|nil|

Also supports:

 - [organization](#common-organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)
 - [exec](#common-exec)
 - [kill](#common-kill)
 - [resource-control](#common-resource-control)

<a name="systemd-target"></a>**systemd\_target**

Unit which describes a systemd target, used for grouping units and
synchronization points during system start-up.
[Documentation][target]

This unit has no specific options.

Also supports:

 - [organization](#common-organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)

<a name="systemd-timer"></a>**systemd\_timer**

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

 - [organization](#common-organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)

<a name="daemon-resources"></a>Daemon Resources
-----------------------------------------------

<a name="systemd-journald"></a>**systemd\_journald**

<a name="systemd-logind"></a>**systemd\_logind**

<a name="systemd-resolved"></a>**systemd\_resolved**

<a name="systemd-timesyncd"></a>**systemd\_timesyncd**



<a name="utility-resources"></a>Utility Resources
-------------------------------------------------

<a name="systemd-bootchart"></a>**systemd\_bootchart**

<a name="systemd-coredump"></a>**systemd\_coredump**

<a name="systemd-sleep"></a>**systemd\_sleep**

<a name="systemd-system"></a>**systemd\_system**

<a name="systemd-user"></a>**systemd\_user**


<a name="misc-resources"></a>Miscellaneous Resources
----------------------------------------------------

<a name="systemd-binfmt-d"></a>**systemd\_binfmt\_d**

<a name="systemd-modules"></a>**systemd\_modules**

<a name="systemd-networkd-link"></a>**systemd\_networkd\_link**

<a name="systemd-sysctl"></a>**systemd\_sysctl**

<a name="systemd-sysuser"></a>**systemd\_sysuser**

<a name="systemd-tmpfile"></a>**systemd\_tmpfile**

<a name="systemd-udev-rules"></a>**systemd\_udev\_rules**


<a name="common-resource-attributes"></a>Common Resource Attributes
-------------------------------------------------------------------

<a name="common-organization"></a>**Organization**

special no-op attributes that yield a block for the purpose of being
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

<a name="common-exec"></a>**Exec**

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

<a name="common-kill"></a>**Kill**

Process killing procedure configuration. [Documentation][kill]

|Attribute|Description|Default|
|---------|-----------|-------|
|kill_mode|see docs|nil|
|kill_signal|see docs|nil|
|send_sighup|see docs|nil|
|send_sigkill|see docs|nil|

<a name="common-resource-control"></a>**Resource Control**

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

<a name="common-unit"></a>**Unit**

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

<a name="common-install"></a>**Install**

Carries installation information for units. Used exclusively by
enable/disable commands of `systemctl`. [Documentation][install]

|Attribute|Description|Default|
|---------|-----------|-------|
|aliases|array of aliases|[]|
|also|see docs|nil|
|default_instance|see docs|nil|
|required_by|see docs|nil|
|wanted_by|see docs|nil|

<a name="common-drop-in"></a>**Drop-In**

Cookbook-specific attributes that activate and control drop-in mode for units.

|Attribute|Description|Default|
|---------|-----------|-------|
|drop_in|boolean which sets if resource is a drop-in unit|false|
|override|which unit to override, prefix only. suffix determined by resource unit type (e.g. "ssh" on a systemd_service -> "ssh.service.d")|nil|
|overrides|drop-in unit options that require a reset (e.g. "ExecStart" -> "ExecStart=" at top of section)|[]|

--
[blog]: http://0pointer.de/blog/projects/systemd-for-admins-1.html
[chef]: https://chef.io
[docs]: http://www.freedesktop.org/wiki/Software/systemd/
[rhel]: https://access.redhat.com/articles/754933
