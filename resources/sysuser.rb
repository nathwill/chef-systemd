resource_name :systemd_sysuser
provides :systemd_sysuser

property :type, String, equal_to: %w(u g m r), default: 'u'
property :sysuser_name, String, name_property: true, identity: true, callbacks: {
  'is less than 31 chars' => ->(s) { s.length <= 31 },
  'is ascii' => ->(s) { s.ascii_only? },
  'has non-digit first char' => ->(s) { !s[0].match(/\d/) },
}
property :id, [String, Integer], callbacks: {
  'is not a reserved id' => ->(s) { !%w(65535 4294967295).include?(s.to_s) },
}
property :gecos, String, default: '-'
property :home, String, default: '-'

def as_string
  "#{type} #{name} #{id} \"#{gecos}\" #{home}"
end

default_action :create

%w(create delete).map(&:to_sym).each do |actn|
  action actn do
    dir = '/etc/sysusers.d'
    path = "#{dir}/#{new_resource.name}.conf"

    directory dir do
      not_if { new_resource.action == :delete }
    end

    execute "systemd-sysusers #{path}" do
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
