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

Also supports: [unit][common_unit], [install][common_install]

### systemd_mount

Unit which describes a file system mount point controlled by systemd.
[Documentation][mount]

|Attribute|Description|Default|
|---------|-----------|-------|
||||

Also supports: [unit][common_unit], [install][common_install]

### systemd_path

Unit which describes information about a path monitored by systemd for
path-based activities.
[Documentation][path]


|Attribute|Description|Default|
|---------|-----------|-------|
||||

Also supports: [unit][common_unit], [install][common_install]

### systemd_service

Unit which describes information about a process controlled and supervised by systemd.
[Documentation][service]

|Attribute|Description|Default|
|---------|-----------|-------|
||||

Also supports: [unit][common_unit], [install][common_install]

### systemd_slice

Unit which describes a "slice" of the system; useful for managing resources
for of a group of processes.
[Documentation][slice]

|Attribute|Description|Default|
|---------|-----------|-------|
||||

Also supports: [unit][common_unit], [install][common_install]

### systemd_socket

Unit which describes an IPC, network socket, or file-system FIFO controlled
and supervised by systemd for socket-based service activation.
[Documentation][socket]

|Attribute|Description|Default|
|---------|-----------|-------|
||||

Also supports: [unit][common_unit], [install][common_install]

### systemd_swap

Unit which describes a swap device or file for memory paging.
[Documentation][swap]

|Attribute|Description|Default|
|---------|-----------|-------|
||||

Also supports: [unit][common_unit], [install][common_install]

### systemd_target

Unit which describes a systemd target, used for grouping units and
synchronization points during system start-up.
[Documentation][target]

This unit has no specific options.

Also supports: [unit][common_unit], [install][common_install]

### systemd_timer

Unit which describes a timer managed by systemd, for timer-based unit
activation (typically a service of the same name).
[Documentation][timer]

|Attribute|Description|Default|
|---------|-----------|-------|
||||

Also supports: [unit][common_unit], [install][common_install]

## Common Attributes

### unit

|Attribute|Description|Default|
|---------|-----------|-------|
||||

### install

|Attribute|Description|Default|
|---------|-----------|-------|
||||

### kill

|Attribute|Description|Default|
|---------|-----------|-------|
||||

### exec

|Attribute|Description|Default|
|---------|-----------|-------|
||||

### resource-control

|Attribute|Description|Default|
|---------|-----------|-------|
||||

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
[service]: http://www.freedesktop.org/software/systemd/man/systemd.service.html
[slice]: http://www.freedesktop.org/software/systemd/man/systemd.slice.html
[socket]: http://www.freedesktop.org/software/systemd/man/systemd.socket.html
[swap]: http://www.freedesktop.org/software/systemd/man/systemd.swap.html
[target]: http://www.freedesktop.org/software/systemd/man/systemd.target.html
[timer]: http://www.freedesktop.org/software/systemd/man/systemd.timer.html
[travis]: https://travis-ci.org/nathwill/chef-systemd
[unit]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html#%5BUnit%5D%20Section%20Options
[units]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html
