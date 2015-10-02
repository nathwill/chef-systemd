require 'spec_helper'

describe Chef::Resource::SystemdUdevRules do
  let(:udev_rules) do
    u = Chef::Resource::SystemdUdevRules.new('udev_rules')
    u.rules [
      [
        {'key' => 'SUBSYSTEM', 'operator' => '==', 'value' => 'block'},
        {'key' => 'ENV{DM_NAME}', 'operator' => '==', 'value' => 'docker-*'},
        {'key' => 'ENV{UDISKS_IGNORE}', 'operator' => '=', 'value' => 1}
      ],
      [
        {'key' => 'SUBSYSTEM', 'operator' => '==', 'value' => 'block'},
        {'key' => 'DEVPATH', 'operator' => '==', 'value' => '/devices/virtual/block/loop*'},
        {'key' => 'ATTR{loop/backing_file}', 'operator' => '==', 'value' => '/var/lib/docker/*'},
        {'key' => 'ENV{UDISKS_IGNORE}', 'operator' => '=', 'value' => 1}
      ]
    ]
    u
  end

  let(:str) do
    "SUBSYSTEM==\"block\", ENV{DM_NAME}==\"docker-*\", ENV{UDISKS_IGNORE}=\"1\"\nSUBSYSTEM==\"block\", DEVPATH==\"/devices/virtual/block/loop*\", ATTR{loop/backing_file}==\"/var/lib/docker/*\", ENV{UDISKS_IGNORE}=\"1\""
  end

  it 'generates a proper hash' do
    expect(udev_rules.as_string).to eq str
  end
end
