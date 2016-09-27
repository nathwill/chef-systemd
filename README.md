systemd chef cookbook
=====================

[![Cookbook](http://img.shields.io/cookbook/v/systemd.svg)](https://github.com/nathwill/chef-systemd)
[![Build Status](https://travis-ci.org/nathwill/chef-systemd.svg?branch=master)](https://travis-ci.org/nathwill/chef-systemd)

A resource-driven [Chef][chef] cookbook for managing GNU/Linux systems via [systemd][docs].

<a name="toc">Table of Contents</a>
===================================

 - [Recommended Reading](#recommended-reading)
 - [Usage Tips](#usage-tips)

<a name="recommended-reading">Recommended Reading</a>
=====================================================

 - This README
 - [Overview of systemd for RHEL 7][rhel]
 - [systemd docs][docs]
 - [Lennart's blog series][blog]
 - libraries in `libraries/*.rb`
 - test cookbook in `test/fixtures/cookbooks/setup`

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
