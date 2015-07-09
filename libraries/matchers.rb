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
  actions = %w(create delete)
  unit_types.each do |type|
    ChefSpec.define_matcher("systemd_#{type}".to_sym)
    actions.each do |action|
      define_method("#{action}_systemd_#{type}".to_sym) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(
          "systemd_#{type}".to_sym,
          action.to_sym,
          resource_name
        )
      end
    end
  end
end
