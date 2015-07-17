require 'spec_helper'

describe Systemd::Helpers do
  let(:unit) do
    Chef::Resource::SystemdService.new('unit')
  end

  let(:drop_in) do
    d = Chef::Resource::SystemdService.new('drop_in')
    d.drop_in(true)
    d.override 'httpd'
    d
  end

  it 'lists the correct stub units' do
    expect(Systemd::Helpers::STUB_UNITS).to match_array [:device, :target]
  end

  it 'lists the correct unit types' do
    expect(Systemd::Helpers::UNIT_TYPES).to match_array [
      :service, :socket, :device, :mount, :automount,
      :swap, :target, :path, :timer, :slice
    ]
  end

  it 'sets the appropriate local configuration root' do
    expect(Systemd::Helpers.local_conf_root).to eq '/etc/systemd'
  end

  it 'sets the appropriate unit configuration root' do
    expect(Systemd::Helpers.unit_conf_root).to eq '/etc/systemd/system'
  end

  it 'sets the appropriate drop_in root' do
    expect(Systemd::Helpers.unit_drop_in_root(drop_in)).to eq '/etc/systemd/system/httpd.service.d'
  end

  it 'sets the appropriate drop_in path' do
    expect(Systemd::Helpers.unit_path(drop_in)).to eq '/etc/systemd/system/httpd.service.d/drop_in.conf'
  end

  it 'sets the appropriate unit path' do
    expect(Systemd::Helpers.unit_path(unit)).to eq '/etc/systemd/system/unit.service'
  end

  it 'performs a correct hash->ini conversion' do
    expect(
      Systemd::Helpers.ini_config({
        :unit=>["Description=test unit"],
        :install=>[],
        :service=>["MemoryLimit=5M", "User=nobody", "Type=oneshot"]
      })
    ).to eq "[Unit]\nDescription=test unit\n\n[Service]\nMemoryLimit=5M\nUser=nobody\nType=oneshot\n"
  end
end
