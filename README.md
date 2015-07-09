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
|where||nil|
|directory_mode||nil|
|timeout_idle_sec||nil|

Also supports: [unit][common_unit], [install][common_install]

### systemd_device

|Attribute|Description|Default|
|---------|-----------|-------|

### systemd_mount

|Attribute|Description|Default|
|---------|-----------|-------|

### systemd_path

|Attribute|Description|Default|
|---------|-----------|-------|

### systemd_service

|Attribute|Description|Default|
|---------|-----------|-------|

### systemd_slice

|Attribute|Description|Default|
|---------|-----------|-------|

### systemd_socket

|Attribute|Description|Default|
|---------|-----------|-------|

### systemd_swap

|Attribute|Description|Default|
|---------|-----------|-------|

### systemd_target

|Attribute|Description|Default|
|---------|-----------|-------|

### systemd_timer

|Attribute|Description|Default|
|---------|-----------|-------|

## Common Attributes

### unit

|Attribute|Description|Default|
|---------|-----------|-------|

### install

|Attribute|Description|Default|
|---------|-----------|-------|

### kill

|Attribute|Description|Default|
|---------|-----------|-------|

### exec

|Attribute|Description|Default|
|---------|-----------|-------|

### resource-control

|Attribute|Description|Default|
|---------|-----------|-------|


[automount]: http://www.freedesktop.org/software/systemd/man/systemd.automount.html
[blog]: http://0pointer.de/blog/projects/systemd-for-admins-1.html
[chef]: https://chef.io
[common_install]: #install
[common_unit]: #unit
[docs]: http://www.freedesktop.org/wiki/Software/systemd/
[ini]: https://en.wikipedia.org/wiki/INI_file
[install]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html#%5BInstall%5D%20Section%20Options
[rhel]: https://access.redhat.com/articles/754933
[travis]: https://travis-ci.org/nathwill/chef-systemd
[unit]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html#%5BUnit%5D%20Section%20Options
[units]: http://www.freedesktop.org/software/systemd/man/systemd.unit.html

