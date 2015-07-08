if defined?(ChefSpec)
  def create_systemd_automount(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_automount, :create, resource_name)
  end

  def delete_systemd_automount(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_automount, :delete, resource_name)
  end

  def create_systemd_timer(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_timer, :create, resource_name)
  end

  def delete_systemd_timer(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_timer, :delete, resource_name)
  end

  def create_systemd_target(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_target, :create, resource_name)
  end

  def delete_systemd_target(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_target, :delete, resource_name)
  end

  def create_systemd_swap(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_swap, :create, resource_name)
  end

  def delete_systemd_swap(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_swap, :delete, resource_name)
  end

  def create_systemd_socket(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_socket, :create, resource_name)
  end

  def delete_systemd_socket(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_socket, :delete, resource_name)
  end

  def create_systemd_slice(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_slice, :create, resource_name)
  end

  def delete_systemd_slice(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_slice, :delete, resource_name)
  end

  def create_systemd_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_service, :create, resource_name)
  end

  def delete_systemd_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_service, :delete, resource_name)
  end

  def create_systemd_path(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_path, :create, resource_name)
  end

  def delete_systemd_path(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_path, :delete, resource_name)
  end

  def create_systemd_mount(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_mount, :create, resource_name)
  end

  def delete_systemd_mount(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_mount, :delete, resource_name)
  end

  def create_systemd_device(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_device, :create, resource_name)
  end

  def delete_systemd_device(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:systemd_device, :delete, resource_name)
  end
end
