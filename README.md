Systemd Chef Cookbook
=====================

[![Cookbook](http://img.shields.io/cookbook/v/systemd.svg)](https://github.com/nathwill/chef-systemd)
[![Build Status](https://travis-ci.org/nathwill/chef-systemd.svg?branch=master)](https://travis-ci.org/nathwill/chef-systemd)

A resource-driven [Chef][chef] cookbook for managing GNU/Linux systems via [systemd][docs].

<a name="toc">Table of Contents</a>
===================================

 - [Recommended Reading](#recommended-reading)
 - [Usage Tips](#usage-tips)
 - [Attributes](#attributes)
 - [Recipes](#recipes)
   - [Daemons](#daemon-recipes)
   - [Utilities](#utility-recipes)
   - [Helpers](#helper-recipes)
 - [Resources](#resources)
   - [Units](#unit-resources)
     - [systemd_automount](#systemd-automount)
     - [systemd_mount](#systemd-mount)
     - [systemd_path](#systemd-path)
     - [systemd_service](#systemd-service)
     - [systemd_slice](#systemd-slice)
     - [systemd_socket](#systemd-socket)
     - [systemd_swap](#systemd-swap)
     - [systemd_target](#systemd-target)
     - [systemd_timer](#systemd-timer)
   - [Daemons](#daemon-resources)
     - [systemd_journald](#systemd-journald)
     - [systemd_logind](#systemd-logind)
     - [systemd_resolved](#systemd-resolved)
     - [systemd_timesyncd](#systemd-timesyncd)
   - [Utilities](#utility-resources)
     - [systemd_bootchart](#systemd-bootchart)
     - [systemd_coredump](#systemd-coredump)
     - [systmd_sleep](#systemd-sleep)
     - [systemd_run](#systemd-run)
   - [Miscellaneous](#misc-resources)
     - [systemd_system](#systemd-system)
     - [systemd_user](#systemd-user)
     - [systemd_binfmt](#systemd-binfmt)
     - [systemd_modules](#systemd-modules)
     - [systemd_networkd_link](#systemd-networkd-link)
     - [systemd_sysctl](#systemd-sysctl)
     - [systemd_sysuser](#systemd-sysuser)
     - [systemd_tmpfile](#systemd-tmpfile)
     - [systemd_udev_rules](#systemd-udev-rules)
   - [Common Attributes](#common-resource-attributes)
     - [Organization](#common-organization)
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

<a name="usage-tips">Usage Tips</a>
===================================

Drop Ins
--------

Systemd provides support for "drop-in" units that work really well for config-
mgmt systems; rather than taking over an entire unit definition, you can apply
custom configuration (e.g. resource limits) that will be merged into the vendor-
provided unit. It's recommended to use these when modifying units installed via
the package manager. See [drop-in](#common-drop-in) docs for more info.

Daemon Reloads
--------------

By default, changes to unit resources will be applied to the system immediately
via calls to `systemctl daemon-reload`. However, on systems with large numbers
of units, daemon-reload can be [problematic][sd-reload]. For users encountering
problems (hangs, slowness) with `systemctl daemon-reload` calls, this cookbook
allows users to disable daemon-reloads by setting the `auto_reload` attribute
to `false`.

In some cases, it may be possible to avoid daemon-reload entirely by using the
`set_properties` action. However, only a subset of unit properties are supported
by `systemctl set-property`, so, unfortunately, in some cases a daemon-reload
may be unavoidable. For these cases, it's possible run a daemon-reload *once*
at the end of a converge.

This cookbook provides the `daemon_reload` recipe to help with this. It removes
the need to have every resource send a notification, and triggers a reload at
the end of a converge if any `auto_reload false` units have been updated.

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

<a name="helper-recipes">Helper Recipes</a>
-------------------------------------------
 - **daemon_reload**: run delayed daemon-reload (for use with auto_reload false)

<a name="resources"></a>Resources
=================================

<a name="unit-resources"></a>Unit Resources
-------------------------------------------

All unit resources support the following actions:

|Action|Description|
|------|-----------|
|:create|render unit configuration file from attributes|
|:delete|delete unit configuration file|
|:enable|enable the unit at boot, unless static (lacks [Install] section)|
|:disable|disables the unit at boot, unless static|
|:start|starts the unit|
|:stop|stops the unit|
|:restart|restarts the unit|
|:reload|reloads the unit|
|:set_properties|runs `systemctl --runtime set-property` for unit configuration|

**Important**: The notable exception is when the unit is a drop-in unit,
in which case it supports only the `:create`, `:delete`, and `:set_properties` actions.

<a name="systemd-automount"></a>**systemd\_automount**

Unit which describes a file system automount point controlled by systemd.
[Documentation][automount]

Example usage (always paired with a mount unit):

```ruby
systemd_mount 'proc-sys-fs-binfmt_misc' do
  description 'Arbitrary Executable File Formats File System'
  default_dependencies false
  mount do
    what 'binfmt_misc'
    where '/proc/sys/fs/binfmt_misc'
    type 'binfmt_misc'
  end
end

systemd_automount 'proc-sys-fs-binfmt_misc' do
  description 'Arbitrary Executable File Formats File System Automount Point'
  default_dependencies false
  before 'sysinit.target'
  condition_path_exists '/proc/sys/fs/binfmt_misc/'
  condition_path_is_read_write '/proc/sys/'
  automount do
    where '/proc/sys/fs/binfmt_misc'
  end
end
```

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

--

<a name="systemd-mount"></a>**systemd\_mount**

Unit which describes a file system mount point controlled by systemd.
[Documentation][mount]

Example usage:

```ruby
systemd_mount 'tmp' do
  description 'Temporary Directory'
  condition_path_is_symbolic_link '!/tmp'
  default_dependencies false
  conflicts 'umount.target'
  before %w( local-fs.target umount.target )
  mount do
    what 'tmpfs'
    where '/tmp'
    type 'tmpfs'
    options 'mode=1777,strictatime,noexec,nosuid'
  end
end
```

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

--

<a name="systemd-path"></a>**systemd\_path**

Unit which describes information about a path monitored by systemd for
path-based activities.
[Documentation][path]

Example usage (showing cups service activation when work is available):

```ruby
systemd_path 'cups' do
  description 'CUPS Scheduler'
  install do
    wanted_by 'multi-user.target'
  end
  path do
    path_exists_glob '/var/spool/cups/d*'
  end
  action [:create, :enable, :start]
end

systemd_service 'cups' do
  description 'CUPS Scheduler'
  after 'network.target'
  install do
    wanted_by 'printer.target'
    also %w( cups.socket cups.path )
  end
  service do
    type 'notify'
    exec_start '/usr/sbin/cupsd -l'
  end
end
```

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

--

<a name="systemd-service"></a>**systemd\_service**

Unit which describes information about a process controlled and supervised by
systemd. [Documentation][service].

While there is some overlap with the `service` resource in Chef-core,
this resource is more narrowly focused on service unit config/management on
systemd-based platforms, whereas the Chef-core service resource works
across multiple service-management frameworks.

As such, while it is *possible* to perform lifecycle management of services
on systemd platforms using the `systemd_service` resource, the systemd cookbook
authors do not recommend doing so. Instead, it is recommended to pair
`systemd_service` instances with platform-agnostic service resources,
as demonstrated below.

Example usage:

```ruby
cookbook_file '/etc/init/httpd.conf' do
  source 'httpd.conf'
  only_if { ::File.executable?('/sbin/initctl') } # Upstart
end

systemd_service 'httpd' do
  description 'Apache HTTP Server'
  after %w( network.target remote-fs.target nss-lookup.target )
  install do
    wanted_by 'multi-user.target'
  end
  service do
    environment 'LANG' => 'C'
    exec_start '/usr/sbin/httpd $OPTIONS -DFOREGROUND'
    exec_reload '/usr/sbin/httpd $OPTIONS -k graceful'
    kill_signal 'SIGWINCH'
    kill_mode 'mixed'
    private_tmp true
  end
  only_if { ::File.open('/proc/1/comm').gets.chomp == 'systemd' } # systemd
end

service 'httpd' do
  action [:enable, :start]
end
```

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

--

<a name="systemd-slice"></a>**systemd\_slice**

Unit which describes a "slice" of the system; useful for managing resources
for of a group of processes.
[Documentation][slice]

This resource has no specific options.

Example usage:

```ruby
systemd_slice 'user' do
  description 'User and Session Slice'
  documentation 'man:systemd.special(7)'
  before 'slices.target'
end
```

Also supports:

 - [organization](#common-organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)
 - [resource-control](#common-resource-control)

--

<a name="systemd-socket"></a>**systemd\_socket**

Unit which describes an IPC, network socket, or file-system FIFO controlled
and supervised by systemd for socket-based service activation.
[Documentation][socket]

Example usage:

```ruby
# Set up OpenSSH Server socket-activation
systemd_socket 'sshd' do
  description 'OpenSSH Server Socket'
  documentation 'man:sshd(8) man:sshd_config(5)'
  conflicts 'sshd.service'
  install do
    wanted_by 'sockets.target'
  end
  socket do
    listen_stream 22
    accept true
  end
  action [:create, :enable, :start]
end

# No need to enable/start the service, the socket-activation will
systemd_service 'sshd' do
  description 'OpenSSH Server Daemon'
  documentation 'man:sshd(8) man:sshd_config(5)'
  after %w( network.target sshd-keygen.service )
  wants %w( sshd-keygen.service )
  service do
    environment_file '/etc/sysconfig/sshd'
    exec_start '/usr/sbin/sshd -D $OPTIONS'
    exec_reload '/bin/kill -HUP $MAINPID'
    kill_mode 'process'
    restart 'on-failure'
    restart_sec '42s'
  end
  install do
    wanted_by 'multi-user.target'
  end
end
```

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

--

<a name="systemd-swap"></a>**systemd\_swap**

Unit which describes a swap device or file for memory paging.
[Documentation][swap]

Example usage:

```ruby
systemd_swap 'dev-vdb' do
  install do
    wanted_by 'swap.target'
  end
  swap do
    what '/dev/vdb'
  end
end
```

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

--

<a name="systemd-target"></a>**systemd\_target**

Unit which describes a systemd target, used for grouping units and
synchronization points during system start-up.
[Documentation][target]

This unit has no specific options.

Example usage:

```ruby
systemd_target 'plague' do
  description 'Never fear, I is here.'
  documentation 'man:systemd.special(7)'
end
```

Also supports:

 - [organization](#common-organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)

--

<a name="systemd-timer"></a>**systemd\_timer**

Unit which describes a timer managed by systemd, for timer-based unit
activation (typically a service of the same name).
[Documentation][timer]

Example usage:

```ruby
# Given this example service
systemd_service 'mlocate-updatedb' do
  description 'Update a database for mlocate'
  service do
    type 'oneshot'
    exec_start '/usr/libexec/mlocate-run-updatedb'
    nice 19
    io_scheduling_class 2
    io_scheduling_priority 7
    private_tmp true
    private_devices true
    private_network true
    protect_system true
  end
end

# Set up a corresponding timer unit
systemd_timer 'mlocate-updatedb' do
  description 'Updates mlocate database every day'
  install do
    wanted_by 'timers.target'
  end
  timer do
    on_calendar 'daily'
    accuracy_sec '24h'
    persistent true
  end
  action [:create, :enable, :start]
end
```

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
|randomized_delay_sec|see docs|nil|
|unit|see docs|nil|
|wake_system|see docs|nil|

Also supports:

 - [organization](#common-organization)
 - [unit](#common-unit)
 - [install](#common-install)
 - [drop-in](#common-drop-in)

<a name="daemon-resources"></a>Daemon Resources
-----------------------------------------------

Resources for managing configuration of common systemd daemons.

All daemon resources support the following actions:

|Action|Description|
|------|-----------|
|:create|render the configuration file|
|:delete|delete the configuration file|

<a name="systemd-journald"></a>**systemd\_journald**

Resource for configuring [systemd-journald][journald]

Example use:

```ruby
systemd_journald 'forward-to-syslog' do
  forward_to_syslog true
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
|storage|see docs|nil|
|compress|see docs|nil|
|seal|see docs|nil|
|split_mode|see docs|nil|
|rate_limit_interval|see docs|nil|
|rate_limit_burst|see docs|nil|
|system_max_use|see docs|nil|
|system_max_files|see docs|nil|
|system_keep_free|see docs|nil|
|system_max_file_size|see docs|nil|
|runtime_max_use|see docs|nil|
|runtime_max_files|see docs|nil|
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

Also supports:

 - [drop-in](#common-drop-in)

--

<a name="systemd-logind"></a>**systemd\_logind**

Resource for configuring [systemd-logind][logind]

Example use:

```ruby
systemd_logind 'power-down-when-idle' do
  idle_action 'hibernate'
  idle_action_sec 3_600
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
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

Also supports:

 - [drop-in](#common-drop-in)

--

<a name="systemd-resolved"></a>**systemd\_resolved**

Resource for configuring [systemd-resolved][resolved]

|Attribute|Description|Default|
|---------|-----------|-------|
|dns|see docs|nil|
|fallback_dns|see docs|nil|
|llmnr|see docs|nil|

Example usage:

```ruby
systemd_resolved 'enable-llmnr' do
  llmnr true
end
```

Also supports:

 - [drop-in](#common-drop-in)

--

<a name="systemd-timesyncd"></a>**systemd\_timesyncd**

Resource for configuring [systemd-timesyncd][timesync]

Example usage:

```ruby
systemd_timesyncd 'my-resolver' do
  ntp %w( 1.2.3.4 2.3.4.5 )
  fallback_ntp %w( 8.8.8.8 8.8.4.4 )
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
|ntp|see docs|nil|
|fallback_ntp|see docs|nil|

Also supports:

 - [drop-in](#common-drop-in)

<a name="utility-resources"></a>Utility Resources
-------------------------------------------------

Resources for configuring common systemd utilities.

All utility resources support the following actions:

|Action|Description|
|------|-----------|
|:create|render the configuration file|
|:delete|delete the configuration file|

<a name="systemd-bootchart"></a>**systemd\_bootchart**

Resource for configuring [systemd-bootchart][bootchart]

Example usage:

```ruby
systemd_bootchart 'include-cgroup-info' do
  control_group true
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
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

Also supports:

 - [drop-in](#common-drop-in)

--

<a name="systemd-coredump"></a>**systemd\_coredump**

Resource for configuring [systemd-coredump][coredump]

Example usage:

```ruby
systemd_coredump 'compress-coredumps' do
  compress true
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
|storage|see docs|nil|
|compress|see docs|nil|
|process_size_max|see docs|nil|
|external_size_max|see docs|nil|
|journal_size_max|see docs|nil|
|max_use|see docs|nil|
|keep_free|see docs|nil|

Also supports:

 - [drop-in](#common-drop-in)

--

<a name="systemd-sleep"></a>**systemd\_sleep**

Resource for configuring [systemd-sleep][sleep]

Example usage:

```ruby
systemd_sleep 'freeze-suspend' do
  suspend_state 'freeze'
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
|suspend_mode|see docs|nil|
|hibernate_mode|see docs|nil|
|hybrid_sleep_mode|see docs|nil|
|suspend_state|see docs|nil|
|hibernate_state|see docs|nil|
|hybrid_sleep_state|see docs|nil|

Also supports:

 - [drop-in](#common-drop-in)

<a name="systemd-run"></a>**systemd\_run**

Resource for running (optionally) resource-constrained transient units
with [systemd-run][run]. Think of it like an "execute" resource with cgroups.

Example usage:

```ruby
systemd_run 'sshd-2222.service' do
  command ''/usr/sbin/sshd -D -o Port=2222'
  cpu_shares 1_024
  nice 19
  service_type 'simple'
  kill_mode 'mixed'
end
```

|Attribute|Description|
|---------|-----------|
|unit|name of transient unit|
|command|the command to run|
|service_type|same as service unit Type directive|
|setenv|`Hash` of env vars|
|timer_property|`Hash` of timer properties|
|delegate|see docs|
|cpu_accounting|see docs|
|cpu_quota|see docs|
|cpu_shares|see docs|
|block_io_accounting|see docs|
|block_io_weight|see docs|
|block_io_read_bandwidth|see docs|
|block_io_write_bandwidth|see docs|
|block_io_device_weight|see docs|
|memory_accounting|see docs|
|memory_limit|see docs|
|device_policy|see docs|
|device_allow|see docs|
|tasks_accounting|see docs|
|tasks_max|see docs|
|user|see docs|
|group|see docs|
|syslog_identifier|see docs|
|syslog_facility|see docs|
|syslog_level|see docs|
|nice|see docs|
|tty_path|see docs|
|working_directory|see docs|
|root_directory|see docs|
|standard_input|see docs|
|standard_output|see docs|
|standard_error|see docs|
|ignore_sigpipe|see docs|
|ttyv_hangup|see docs|
|tty_reset|see docs|
|private_tmp|see docs|
|private_devices|see docs|
|private_network|see docs|
|no_new_privileges|see docs|
|syslog_level_prefix|see docs|
|utmp_identifier|see docs|
|utmp_mode|see docs|
|pam_name|see docs|
|environment|see docs|
|environment_file|see docs|
|timer_slack_n_sec|see docs|
|oom_score_adjust|see docs|
|pass_environment|see docs|
|read_write_directories|see docs|
|read_only_directories|see docs|
|inaccessible_directories|see docs|
|protect_system|see docs|
|protect_home|see docs|
|runtime_directory|see docs|
|limit_cpu|see docs|
|limit_fsize|see docs|
|limit_data|see docs|
|limit_stack|see docs|
|limit_core|see docs|
|limit_rss|see docs|
|limit_nofile|see docs|
|limit_as|see docs|
|limit_nproc|see docs|
|limit_memlock|see docs|
|limit_locks|see docs|
|limit_sigpending|see docs|
|limit_msgqueue|see docs|
|limit_nice|see docs|
|limit_rtprio|see docs|
|limit_rttime|see docs|
|kill_mode|see docs|
|kill_signal|see docs|
|send_sigkill|see docs|
|what|see docs|
|type|see docs|
|options|see docs|
|exec_start|see docs|
|on_active_sec|see docs|
|on_boot_sec|see docs|
|on_startup_sec|see docs|
|on_unit_active_sec|see docs|
|on_unit_inactive_sec|see docs|
|on_calendar|see docs|
|accuracy_sec|see docs|
|wake_system|see docs|
|remain_after_elapse|see docs|
|random_sec|see docs|
|default_dependencies|see docs|
|requires|see docs|
|requires_overridable|see docs|
|requisite|see docs|
|requisite_overridable|see docs|
|wants|see docs|
|binds_to|see docs|
|part_of|see docs|
|conflicts|see docs|
|before|see docs|
|after|see docs|
|on_failure|see docs|
|propagates_reload_to|see docs|
|reload_propagated_from|see docs|
|description|see docs|
|slice|see docs|
|uid|see docs|
|gid|see docs|
|host|see docs|
|machine|see docs|
|scope|see docs|
|remain_after_exit|see docs|
|send_sighup|see docs|
|no_block|see docs|
|on_active|see docs|
|on_boot|see docs|
|on_startup|see docs|
|on_unit_active|see docs|
|on_unit_inactive|see docs|

<a name="misc-resources"></a>Miscellaneous Resources
----------------------------------------------------

<a name="systemd-system"></a>**systemd\_system**

Resource for configuring systemd system service [manager][system]:

`systemd_system` supports the following actions:

|Action|Description|
|------|-----------|
|:create|render the configuration file to disk|
|:delete|delete the configuration file|


Example usage:

```ruby
systemd_system 'reboot-on-crash' do
  crash_reboot true
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
|log_level|see docs|nil|
|log_target|see docs|nil|
|log_color|see docs|nil|
|log_location|see docs|nil|
|dump_core|see docs|nil|
|crash_shell|see docs|nil|
|crash_reboot|see docs|nil|
|show_status|see docs|nil|
|crash_ch_vt|see docs|nil|
|crash_change_vt|see docs|nil|
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
|default_tasks_accounting|see docs|nil|
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

Also supports:

 - [drop-in](#common-drop-in)

--

<a name="systemd-user"></a>**systemd\_user**

Supports same options as the `systemd_system` resource.

--

<a name="systemd-binfmt"></a>**systemd\_binfmt**

Resource for managing [binfmt_misc files][binfmt]
(configure binary formats for executables at boot)

`systemd_binfmt` supports the following actions:

|Action|Description|
|------|-----------|
|:create|render the configuration file to disk|
|:delete|delete the configuration file|

Example usage:

```ruby
systemd_binfmt 'DOSWin' do
  magic 'MZ'
  interpreter '/usr/bin/wine'
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
|name|see docs|nil|
|type|see docs|M|
|offset|see docs|nil|
|magic|see docs|nil|
|mask|see docs|nil|
|interpreter|see docs|nil|
|flags|see docs|nil|

--

<a name="systemd-modules"></a>**systemd\_modules**

Resource for managing [modules][modules]

`systemd_modules` supports the following actions:

|Action|Description|
|------|-----------|
|:create|render the configuration file to disk|
|:delete|delete the configuration file|
|:load|load the module via `modprobe`|
|:unload|remove the module via `modprobe -r`|

Example usage:

```ruby
systemd_modules 'die-beep-die' do
  blacklist true
  modules %w( pcspkr )
  action [:create, :unload]
end

systemd_modules 'zlib' do
  modules %w( zlib )
  action [:create, :load]
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
|blacklist|boolean, controls whether to blacklist or load|false|
|modules|Array, list of modules to act on|[]|

--

<a name="systemd-networkd-link"></a>**systemd\_networkd\_link**

Resource for managing network [devices][link]

`systemd_networkd_link` supports the following actions:

|Action|Description|
|------|-----------|
|:create|render the configuration file to disk|
|:delete|delete the configuration file|

Example usage:

```ruby
systemd_networkd_link 'wireless' do
  match do
    match_mac_addr '12:34:56:78:9a:bc'
    driver 'brcmsmac'
    path 'pci-0000:02:00.0-*'
    type 'wlan'
    virtualization false
    host 'my-laptop'
    architecture 'x86-64'
  end
  link do
    name 'wireless0'
    mtu_bytes 1_450
    bits_per_second '10M'
    wake_on_lan 'magic'
    link_mac_addr 'cb:a9:87:65:43:21'
  end
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
|original_name|see docs|nil|
|path|see docs|nil|
|driver|see docs|nil|
|type|see docs|nil|
|host|see docs|nil|
|virtualization|see docs|nil|
|kernel_command_line|see docs|nil|
|architecture|see docs|nil|
|description|see docs|nil|
|mac_address_policy|see docs|nil|
|name_policy|see docs|nil|
|name|see docs|nil|
|mtu_bytes|see docs|nil|
|bits_per_second|see docs|nil|
|duplex|see docs|nil|
|wake_on_lan|see docs|nil|
|match_mac_addr|MacAddr setting for match section|nil|
|link_mac_addr|MacAddr setting for link section|nil|
|link_alias|Alias setting for link section|nil|

--

<a name="systemd-sysctl"></a>**systemd\_sysctl**

Resource for managing sysctls with [systemd-sysctl][sysctl]

`systemd_sysctl` supports the following actions:

|Action|Description|
|------|-----------|
|:create|render the configuration file to disk|
|:delete|delete the configuration file|
|:apply|apply the sysctl setting|

Example usage:

```ruby
systemd_sysctl 'vm.swappiness' do
  value 10
  action [:create, :apply] # next boot, immediately
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
|name|resource name is sysctl name|resource name|
|value|sysctl value|nil|

--

<a name="systemd-sysuser"></a>**systemd\_sysuser**

Resource for managing system users with [systemd-sysusers][sysusers]

`systemd_sysuser` supports the following actions:

|Action|Description|
|------|-----------|
|:create|render the configuration file to disk|
|:delete|delete the configuration file|

Example usage:

```ruby
systemd_sysuser '_testuser' do
  id 65_530
  gecos 'my test user'
  home '/var/lib/test'
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
|name|resource name is username|resource name|
|type|see docs|u|
|id|see docs|nil|
|gecos|see docs|-|
|home|see docs|-|

--

<a name="systemd-tmpfile"></a>**systemd\_tmpfile**

Resource for managing tmp files with [systemd-tmpfiles][tmpfiles]

`systemd_tmpfile` supports the following actions:

|Action|Description|
|------|-----------|
|:create|render the configuration file to disk|
|:delete|delete the configuration file|

Example usage:

```ruby
systemd_tmpfile 'my-app' do
  path '/tmp/my-app'
  age '10d'
  type 'f'
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
|path|see docs|nil|
|mode|see docs|-|
|uid|see docs|-|
|gid|see docs|-|
|age|see docs|-|
|argument|see docs|-|
|type|see docs|f|

--

<a name="systemd-udev-rules"></a>**systemd\_udev\_rules**

Resource for managing udev [rules][rules] files

`systemd_udev_rules` supports the following actions:

|Action|Description|
|------|-----------|
|:create|render the configuration file to disk|
|:delete|delete the configuration file|
|:disable|disables a udev rule|

Example usage:

```ruby
# hide docker's loopback devices from udisks, and thus from user desktops
systemd_udev_rules 'udev-test' do
  rules [
    [
      {
        'key' => 'SUBSYSTEM',
        'operator' => '==',
        'value' => 'block'
      },
      {
        'key' => 'ENV{DM_NAME}',
        'operator' => '==',
        'value' => 'docker-*'
      },
      {
        'key' => 'ENV{UDISKS_PRESENTATION_HIDE}',
        'operator' => '=',
        'value' => 1
      },
      {
        'key' => 'ENV{UDISKS_IGNORE}',
        'operator' => '=',
        'value' => 1
      }
    ],
    [
      {
        'key' => 'SUBSYSTEM',
        'operator' => '==',
        'value' => 'block'
      },
      {
        'key' => 'DEVPATH',
        'operator' => '==',
        'value' => '/devices/virtual/block/loop*'
      },
      {
        'key' => 'ATTR{loop/backing_file}',
        'operator' => '==',
        'value' => '/var/lib/docker/*'
      },
      {
        'key' => 'ENV{UDISKS_PRESENTATION_HIDE}',
        'operator' => '=',
        'value' => 1
      },
      {
        'key' => 'ENV{UDISKS_IGNORE}',
        'operator' => '=',
        'value' => 1
      }
    ]
  ]
  action [:create]
end
```

|Attribute|Description|Default|
|---------|-----------|-------|
|rules|array of arrays of hashes (see docs & example below)|[]|

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

is the same as...

```ruby
systemd_automount 'vagrant-home' do
  description 'Test Automount'
  wanted_by 'local-fs.target'
  where '/home/vagrant'
end
```
--

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

--

<a name="common-kill"></a>**Kill**

Process killing procedure configuration. [Documentation][kill]

|Attribute|Description|Default|
|---------|-----------|-------|
|kill_mode|see docs|nil|
|kill_signal|see docs|nil|
|send_sighup|see docs|nil|
|send_sigkill|see docs|nil|

--

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
|tasks_accounting|see docs|nil|
|tasks_limit|see docs|nil|
|slice|see docs|nil|
|net_class|see docs|nil|
|startup_block_io_weight|see docs|nil|
|startup_cpu_shares|see docs|nil|

--

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
|auto_reload|whether to execute daemon-reload on unit change|true|
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
|mode|systemd mode, either `:user` or `:system`|`:system`|
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

--

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

--

<a name="common-drop-in"></a>**Drop-In**

Cookbook-specific attributes that activate and control drop-in mode for units.

|Attribute|Description|Default|
|---------|-----------|-------|
|drop_in|boolean which sets if resource is a drop-in unit|true for daemons & utils; false for units|
|override|which unit to target, prefix only. suffix determined by parent resource unit type (e.g. "ssh" on a systemd_service -> "ssh.service" as target unit)|nil|
|overrides|drop-in unit options that require a reset (e.g. "ExecStart" -> "ExecStart=" at top of section)|[]|

--

[automount]: http://www.freedesktop.org/software/systemd/man/systemd.automount.html
[binfmt]: http://www.freedesktop.org/software/systemd/man/binfmt.d.html
[blog]: http://0pointer.de/blog/projects/systemd-for-admins-1.html
[bootchart]: http://www.freedesktop.org/software/systemd/man/bootchart.conf.html
[chef]: https://chef.io
[coredump]: http://www.freedesktop.org/software/systemd/man/coredump.conf.html
[docs]: http://www.freedesktop.org/wiki/Software/systemd/
[exec]: http://www.freedesktop.org/software/systemd/man/systemd.exec.html
[install]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html#[Install]%20Section%20Options
[journald]: http://www.freedesktop.org/software/systemd/man/journald.conf.html
[kill]: http://www.freedesktop.org/software/systemd/man/systemd.kill.html
[link]: http://www.freedesktop.org/software/systemd/man/systemd.link.html
[logind]: http://www.freedesktop.org/software/systemd/man/logind.conf.html
[modules]: http://www.freedesktop.org/software/systemd/man/modules-load.d.html
[mount]: http://www.freedesktop.org/software/systemd/man/systemd.mount.html
[path]: http://www.freedesktop.org/software/systemd/man/systemd.path.html
[resolved]: http://www.freedesktop.org/software/systemd/man/resolved.conf.htm/
[resource_control]: http://www.freedesktop.org/software/systemd/man/systemd.resource-control.html
[rhel]: https://access.redhat.com/articles/754933
[rules]: http://www.freedesktop.org/software/systemd/man/udev.html#Rules%20Files
[run]: https://www.freedesktop.org/software/systemd/man/systemd-run.html
[sd-reload]: https://www.youtube.com/watch?feature=player_detailpage&v=wVk-NWtiIZY#t=385
[service]: http://www.freedesktop.org/software/systemd/man/systemd.service.html
[sleep]: http://www.freedesktop.org/software/systemd/man/systemd-sleep.conf.html
[slice]: http://www.freedesktop.org/software/systemd/man/systemd.slice.html
[socket]: http://www.freedesktop.org/software/systemd/man/systemd.socket.html
[swap]: http://www.freedesktop.org/software/systemd/man/systemd.swap.html
[sysctl]: http://www.freedesktop.org/software/systemd/man/systemd-sysctl.html
[system]: http://www.freedesktop.org/software/systemd/man/systemd-system.conf.html
[sysusers]: http://www.freedesktop.org/software/systemd/man/systemd-sysusers.html
[target]: http://www.freedesktop.org/software/systemd/man/systemd.target.html
[timer]: http://www.freedesktop.org/software/systemd/man/systemd.timer.html
[timesync]: http://www.freedesktop.org/software/systemd/man/timesyncd.conf.html
[tmpfiles]: http://www.freedesktop.org/software/systemd/man/systemd-tmpfiles.html
[unit]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html#[Unit]%20Section%20Options
