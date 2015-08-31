if defined?(ChefSpec)
  units = %w(
    automount
    timer
    target
    swap
    socket
    device
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
  )

  actions = %i(create delete )
  unit_actions = %i( enable disable start stop restart reload )

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
end
