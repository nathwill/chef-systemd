resource_name :systemd_run
provides :systemd_run

property :unit, String, default: name
property :command, String, required: true
property :service_type, Systemd::Service::OPTIONS['Service']['Type']
property :setenv, kind_of: Hash, default: {}
property :timer_property, kind_of: Hash, default: {}

option_properties Systemd::Run::OPTIONS

Systemd::Run::BOOLEANS.each do |prop|
  property prop.to_sym, [TrueClass, FalseClass], default: false
end

Systemd::Run::STRING.each do |prop|
  property prop.to_sym
end

Systemd::Run::ON_SECS.each do |prop|
  property prop.underscore.to_sym, [String, Integer]
end

# rubocop: disable AbcSize
# rubocop: disable MethodLength
def cli_opts
  cmd = ["--unit=#{unit}"]
  cmd << "--service-type=#{service_type}" if service_type

  Systemd::Run::BOOLEANS.each do |prop|
    cmd << "--#{prop.tr('_', '-')}" if send(prop.to_sym)
  end

  %w( STRINGS ON_SECS ).each do |c|
    Systemd::Run.const_get(c).map(&:to_sym).each do |p|
      cmd << "--#{p.to_s.tr('_', '-')}='#{send(p)}'" unless send(p).nil?
    end
  end

  %w( setenv timer_property ).each do |a|
    send(a.to_sym).each_pair do |k, v|
      cmd << "--#{a.tr('_', '-')}=#{k}=#{v}"
    end
  end

  cmd << options_config(Systemd::Run::OPTIONS).map { |o| "-p '#{o}'" }
  cmd.flatten.join(' ')
end
# rubocop: enable AbcSize
# rubocop: enable MethodLength

def active?
  Mixlib::ShellOut.new("systemctl is-active #{unit}")
                  .tap(&:run_command)
                  .stdout
                  .chomp == 'active'
end

default_action :run

action :run do
  cmd = "systemd-run #{new_resource.cli_opts} #{new_resource.command}"
  stop = "systemctl stop #{new_resource.unit}"

  execute stop do
    action :nothing
    only_if { new_resource.active? }
  end

  file "/var/cache/#{new_resource.unit}" do
    content cmd
    notifies :run "execute[#{stop}]", :immediately
  end

  execute cmd do
    not_if { new_resource.active? }
  end
end

action :stop do
  execute "systemctl stop #{new_resource.unit}" do
    only_if { new_resource.active? }
  end
end
