
# hide docker's loopback devices from udisks, and thus from user desktops
systemd_udev_rules 'udev-test' do
  rules [
    [
      {
        'key' => 'SUBSYSTEM',
        'operator' => '==',
        'value' => 'block'
      },
      {
        'key' => 'ENV{DM_NAME}',
        'operator' => '==',
        'value' => 'docker-*'
      },
      {
        'key' => 'ENV{UDISKS_PRESENTATION_HIDE}',
        'operator' => '=',
        'value' => 1
      },
      {
        'key' => 'ENV{UDISKS_IGNORE}',
        'operator' => '=',
        'value' => 1
      }
    ],
    [
      {
        'key' => 'SUBSYSTEM',
        'operator' => '==',
        'value' => 'block'
      },
      {
        'key' => 'DEVPATH',
        'operator' => '==',
        'value' => '/devices/virtual/block/loop*'
      },
      {
        'key' => 'ATTR{loop/backing_file}',
        'operator' => '==',
        'value' => '/var/lib/docker/*'
      },
      {
        'key' => 'ENV{UDISKS_PRESENTATION_HIDE}',
        'operator' => '=',
        'value' => 1
      },
      {
        'key' => 'ENV{UDISKS_IGNORE}',
        'operator' => '=',
        'value' => 1
      }
    ]
  ]
  action [:create]
end
