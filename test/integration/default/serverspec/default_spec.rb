require 'spec_helper'

describe 'systemd::default' do
  describe file('/etc/systemd/system/test-unit.service') do
    it { should be_file }
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Documentation=man:true\(1\)/ }
    its(:content) { should match /\[Install\]/ }
    its(:content) { should match /WantedBy=multi-user.target/ }
    its(:content) { should match /\[Service\]/ }
    its(:content) { should match /User=nobody/ }
    its(:content) { should match /Type=oneshot/ }
    its(:content) { should match /ExecStart=\/usr\/bin\/true/ }
  end
end
