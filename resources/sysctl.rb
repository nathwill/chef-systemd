resource_name :systemd_sysctl
provides :systemd_sysctl

property :value, [String, Numeric, Array], required: true

def to_kv
  "#{name}=#{Array(value).join(' ')}"
end

def to_cli
  "#{name}='#{Array(value).join(' ')}'"
end

default_action :create

%w(create delete).map(&:to_sym).each do |actn|
  action actn do
    file "/etc/sysctl.d/#{new_resource.name}.conf" do
      content new_resource.to_kv
      action actn
    end
  end
end

action :apply do
  current = Mixlib::ShellOut.new("sysctl -n #{new_resource.name}")
                            .tap(&:run_command).stdout.chomp

  execute "sysctl -e -w #{new_resource.to_cli}" do
    not_if { current == Array(new_resource.value).join(' ') }
  end
end
