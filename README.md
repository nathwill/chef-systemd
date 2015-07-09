# systemd chef cookbook [![Build Status](https://travis-ci.org/nathwill/chef-systemd.svg?branch=master)][travis]

A resource-drive [Chef][chef] cookbook for [systemd][docs]. Currently under
construction; see issues for list of ways to contribute :)

Cookbook builds on a core systemd_unit resource in order to provide resources
for the following unit types:

- automount
- device
- mount
- path
- service
- slice
- socket
- swap
- target
- timer

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

### systemd_automount

### systemd_device

### systemd_mount

### systemd_path

### systemd_service

### systemd_slice

### systemd_socket

### systemd_swap

### systemd_target

### systemd_timer

## Common Attributes

### kill

### exec

### resource-control


[blog]: http://0pointer.de/blog/projects/systemd-for-admins-1.html
[chef]: https://chef.io
[docs]: http://www.freedesktop.org/wiki/Software/systemd/
[rhel]: https://access.redhat.com/articles/754933
[travis]: https://travis-ci.org/nathwill/chef-systemd
