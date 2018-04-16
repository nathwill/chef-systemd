# 3.2.3 / 2018-04-16

* remove deprecated compat_resource dependency
* fix precursor option merge

# 3.2.2 / 2018 -03-07

* add options for latest systemd

# 3.2.1 / 2018-02-26

* fix ohai plugin path

# 3.2.0 / 2018-01-22

* change resource sub-block evaluation context to avoid conflict with top-level properties (see #128)

# 3.1.6 / 2018-01-18

* relax required properties or resources
* incorporate foodcritic recommendations

# 3.1.5 / 2017-12-05

* ensure pulling values from new_resource while merging the precursor (thanks @grimm26!)

# 3.1.4 / 2017-11-15

* make some tweaks to appease supermarket quality metrics
* add some legacy option names for compatibility with older systemd

# 3.1.3 / 2017-11-13

* use backports for systemd-container package on debian

# 3.1.2 / 2017-10-31

* remove respond_to_missing? in mixin, which was causing stack level crashes
  when using systemd_* resources inside custom resource definitions (#117)

# 3.1.1 / 2017-08-29

* move requires for dbus to ease use with chefspec

# 3.1.0 / 2017-08-04

* add precursor drop-in property for use in resetting or repeating properties (#110, #111)

# 3.0.2 / 2017-07-18

* fix super use in dsl builder, for REAL (thanks @jklare!)

# 3.0.1 / 2017-07-17

* fix super use in dsl builder

# 3.0.0 / 2017-07-15

*  remove resources that are incompletely implemented or deprecated in systemd
  *  udev_rules
* add machine resources
* use chef 12.5+ custom resources where possible
* refactor unit types to use core systemd_unit resource
* separate drop-in units into their own resource types
* remove/cleanup attributes/recipes that are easily accomplished using provided resources
* consolidate integration test suites so the test matrix is less crazy
* update chefspec matchers
* adjust testing appropriately
* update documentation

# 2.1.3 / 2016-11-22

* add RandomizedDelaySec (thanks @szymonpk!)

# 2.1.2 / 2016-09-22

* add apply action for systemd_sysctl chefspec matcher (thanks @tylermarshall!)

# 2.1.1 / 2016-09-08

* fix incorrect blocking of netdev, network, device unit dependencies (thanks @mfischer-zd!)

# 2.1.0 / 2016-05-18

* indicate Arch Linux(arch) supported

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
