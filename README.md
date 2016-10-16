# systemd chef cookbook

[![Cookbook](http://img.shields.io/cookbook/v/systemd.svg)](https://github.com/nathwill/chef-systemd)
[![Build Status](https://travis-ci.org/nathwill/chef-systemd.svg?branch=master)](https://travis-ci.org/nathwill/chef-systemd)

A resource-driven [Chef][chef] cookbook for managing GNU/Linux systems via [systemd][docs].

## Recommended reading

the systemd project covers a lot of territory, below are some resources that can help with orientation.

 - [Overview of systemd for RHEL 7][rhel]
 - [systemd docs][docs]
 - [Lennart's blog series][blog]

We also provide reference documentation for this cookbook:

 - [resource docs](resources.md)
 - [provided examples](examples.md)

## Overview

### Attributes

The attributes used by this cookbook are under the `systemd` name space.

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

installs btrfs tools required by machined, installs machined utilities, sets machine pool disk size limit

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

#### System Services

|Name|Resource|
|----|--------|
|manager (system)|systemd_system|
|manager (user)|systemd_user|
|journal-remote|systemd_journal_remote|
|journal-upload|systemd_journal_upload|
|journald|systemd_journald|
|logind|systemd_logind|
|resolved|systemd_resolved|
|timesyncd|systemd_timesyncd|

#### Utilities

|Name|Resource|
|----|--------|
|binfmt|systemd_binfmt|
|coredump|systemd_coredump|
|modules|systemd_modules|
|sleep|systemd_sleep|
|sysctl|systemd_sysctl|
|sysuser|systemd_sysuser|
|tmpfile|systemd_tmpfile|

#### Machines

|Name|Resource|
|----|--------|
|machine|systemd_machine|
|machine_image|systemd_machine_image|
|nspawn|systemd_nspawn|

#### Networking

|Name|Resource|
|----|--------|
|network|systemd_network|
|link|systemd_link|
|netdev|systemd_netdev|

--

[blog]: https://www.freedesktop.org/wiki/Software/systemd#thesystemdforadministratorsblogseries
[chef]: https://chef.io
[docs]: http://www.freedesktop.org/wiki/Software/systemd
[rhel]: https://access.redhat.com/articles/754933
