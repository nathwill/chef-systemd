require 'spec_helper'

describe 'Coredump' do
  describe file('/etc/systemd/coredump.conf') do
    it { should be_file }
    its(:content) { should match %r{[Coredump]} }
    its(:content) { should match /Compress=yes/ }
  end
end
