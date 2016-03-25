# 2.0.0 / 2016-03-24

* move namespaces

# 1.2.0 / 2016-03-11

* adds systemd_run resource
* documentation fixes

# 1.1.2 / 2015-11-20

* add missing timer attributes
* more Chef 11 compat fixes

# 1.1.1 / 2015-11-19

* fix Chef 11 compatibility issues

# 1.1.0 / 2015-11-11

* fix testing with dnf-based platforms (fedora)
* add NetClass directive
* add TasksAccounting directives
* add CrashChangeVT directive
* add Writable directive for sockets
* add support for journald vacuum directives ({System,Runtime}MaxFiles)
* add auto_reload unit attribute
* add set_properties unit action
* add daemon_reload recipe
* documentation improvements (new "usage tips" section)

# 1.0.0 / 2015-10-22

* improved docs
* improved matchers
* remove device resource
* support array args to sysctl resource value attribute
* fix udev recipe to support split-usr
* 1.0, whoo!

# 0.4.0 / 2015-10-16

* add binfmt resource
* add udev resource
* add sysuser resource
* reorganize libraries
* reorganize and expand docs

# 0.3.0 / 2015-09-18

* enhanced resource attributes (type, value appropriate)
* add init helpers
* add reload action for service resources

# 0.2.0 / 2015-08-15

* add non-unit resources/providers
* add recipes
* expanded testing
* expanded documentation

# 0.1.2 / 2015-07-29

* hotfix provider

# 0.1.1 / 2015-07-10

* initial release
