if defined?(ChefSpec)
  units = %w(
    automount
    timer
    target
    swap
    socket
    mount
    path
    service
    slice
  )

  daemons = %w(
    journald
    logind
    resolved
    timesyncd
  )

  utils = %w(
    bootchart
    coredump
    sleep
    system
    user
  )

  misc = %w(
    networkd_link
    sysctl
    tmpfile
    binfmt
    modules
    sysuser
    udev_rules
  )

  actions = %w( create delete ).map(&:to_sym)
  unit_actions = %w(
    enable disable start stop restart reload mask unmask set_properties
  ).map(&:to_sym)

  (units | daemons | utils | misc).each do |type|
    ChefSpec.define_matcher("systemd_#{type}".to_sym)
    actions.each do |action|
      define_method("#{action}_systemd_#{type}".to_sym) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(
          "systemd_#{type}".to_sym,
          action, resource_name
        )
      end
    end
  end

  define_method(:set_default_systemd_target) do |resource_name|
    ChefSpec::Matchers::ResourceMatcher.new(
      :systemd_target, :set_default, resource_name
    )
  end

  units.each do |type|
    unit_actions.each do |action|
      define_method("#{action}_systemd_#{type}".to_sym) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(
          "systemd_#{type}".to_sym,
          action, resource_name
        )
      end
    end
  end

  ChefSpec.define_matcher(:systemd_modules)
  %w( load unload ).map(&:to_sym).each do |mod_action|
    define_method("#{mod_action}_systemd_modules") do |resource_name|
      ChefSpec::Matchers::ResourceMatcher.new(
        :systemd_modules, mod_action, resource_name
      )
    end
  end

  ChefSpec.define_matcher(:systemd_run)
  %w( run stop ).map(&:to_sym).each do |run_action|
    define_method("#{run_action}_systemd_run") do |resource_name|
      ChefSpec::Matchers::ResourceMatcher.new(
        :systemd_run, mod_action, resource_name
      )
    end
  end

  ChefSpec.define_matcher(:systemd_udev_rules)
  define_method('disable_systemd_udev_rules') do |resource_name|
    ChefSpec::Matchers::ResourceMatcher.new(
      :systemd_udev_rules, :disable, resource_name
    )
  end
end
