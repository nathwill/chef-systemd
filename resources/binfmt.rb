resource_name :systemd_binfmt
provides :systemd_binfmt

property :binfmt_name, String, name_property: true, identity: true, callbacks: {
  'does not contain /' => ->(s) { !s.match(Regexp.new('/')) },
}
property :type, String, equal_to: %w(M E), default: 'M'
property :offset, Integer, equal_to: 0.upto(127)
property :magic, String, required: true, callbacks: {
  'does not contain /' => ->(s) { !s.match(Regexp.new('/')) },
}
property :mask, String
property :interpreter, String, required: true, callbacks: {
  'is acceptable length' => ->(s) { s.length <= 127 },
}
property :flags, String, callbacks: {
  'only supported flags' => lambda do |spec|
    spec.split(//).all? { |c| %w(P O C).include?(c) }
  end,
}

def as_string
  %w(name type offset magic mask interpreter flags)
    .map { |a| send(a.to_sym) }
    .join(':')
    .prepend(':')
end

default_action :create

%w(create delete).map(&:to_sym).each do |actn|
  action actn do
    path = "/etc/binfmt.d/#{new_resource.name}.conf"

    execute "register-binfmt-#{new_resource.name}" do
      command "/lib/systemd/systemd-binfmt #{path}"
      not_if { new_resource.action == :delete }
      action :nothing
      subscribes :run, "file[#{path}]", :immediately
    end

    file path do
      content new_resource.as_string
      action actn
    end
  end
end
