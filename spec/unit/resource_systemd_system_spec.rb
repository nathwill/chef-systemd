require 'spec_helper'

describe Chef::Resource::SystemdSystem do
  let(:system) do
    s = Chef::Resource::SystemdSystem.new('system')
    s.dump_core 'yes'
    s.crash_shell 'no' # crash override
    s
  end

  let(:hash) do
    {"Manager"=>["DumpCore=yes", "CrashShell=no"]}
  end

  it 'generates a proper hash' do
    expect(system.to_hash).to eq hash
  end
end
