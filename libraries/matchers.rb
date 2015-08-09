if defined?(ChefSpec)
  unit_types = %w(
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

  actions = %i(create delete )
  unit_actions = %i( enable disable start stop restart )

  (unit_types | daemons).each do |type|
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

  unit_types.each do |type|
    unit_actions.each do |action|
      define_method("#{action}_systemd_#{type}".to_sym) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(
          "systemd_#{type}".to_sym,
          action, resource_name
        )
      end
    end
  end

  ChefSpec.define_matcher(:systemd_networkd_link)
  actions.each do |action|
    define_method("#{action}_systemd_networkd_link") do |resource_name|
      ChefSpec::Matchers::ResourceMatcher.new(
        :systemd_networkd_link,
        action, resource_name
      )
    end
  end
end
