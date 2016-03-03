require 'spec_helper'

describe Chef::Resource::SystemdRun do
  let(:svc_run) do
    Chef::Resource::SystemdRun.new("transient-env.service").tap do |r|
      r.command 'env'
      r.service_type 'simple'
      r.setenv({ 'FOO' => 0, 'BAR' => 1 })
      r.description 'transient'
      r.cpu_shares 1_024
      r.nice 19
      r.on_active 15
      r.kill_mode 'mixed'
    end
  end

  let(:svc_opts) do
    [
      "--unit=transient-env.service", "--service-type=simple",
      "--description='transient'","--on-active='15'", "--setenv=FOO=0",
      "--setenv=BAR=1", "-p 'CPUShares=1024'", "-p 'Nice=19'",
      "-p 'KillMode=mixed'"
    ].join(' ')
  end

  it 'generates proper service cli options' do
    expect(svc_run.cli_opts).to eq svc_opts
  end
end
