require 'spec_helper'

describe Systemd::Helpers do
  describe '#module_loaded?' do
    let(:modules) do
      [
        'snd 77824 3 snd_pcsp,snd_pcm,snd_timer, Live 0xffffffffa02b8000',
        'ghash_clmulni_intel 16384 0 - Live 0xffffffffa0253000',
        'e1000 135168 0 - Live 0xffffffffa0296000',
        'soundcore 16384 1 snd, Live 0xffffffffa0258000',
        'acpi_cpufreq 20480 0 - Live 0xffffffffa019e000'
      ].join("\n")
    end

    before(:each) do
      allow(File).to receive(:exist?).with('/proc/modules')
                                     .and_return(true)
      allow(File).to receive(:read).with('/proc/modules')
                                   .and_return(modules)
    end

    it 'returns true for a loaded module' do
      expect(Systemd::Helpers.module_loaded?('e1000')).to eq true
    end

    it 'returns false for an unloaded module' do
      expect(Systemd::Helpers.module_loaded?('xfs')).to eq false
    end
  end

  describe '#systemd_is_pid_1?' do
    before(:each) do
      allow(File).to receive(:exist?).with('/proc/1/comm')
                                     .and_return(true)
    end

    it 'returns true when systemd is pid 1' do
      allow(File).to receive(:read).with('/proc/1/comm')
                                   .and_return('systemd')
      expect(Systemd::Helpers.systemd_is_pid_1?).to eq true
    end

    it 'returns false when systemd is not pid 1' do
      allow(File).to receive(:read).with('/proc/1/comm')
                                   .and_return('init')
      expect(Systemd::Helpers.systemd_is_pid_1?).to eq false
    end
  end

  describe '#rtc_mode?' do
    
  end

  describe '#timezone?' do

  end
end

describe String do
  describe '#underscore' do

  end

  describe '#camelcase' do

  end
end

describe Hash do
  describe '#to_kv_pairs' do

  end
end
