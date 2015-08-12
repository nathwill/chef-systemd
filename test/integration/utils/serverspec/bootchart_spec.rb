require 'spec_helper'

describe 'Bootchart' do
  describe file('/etc/systemd/bootchart.conf') do
    it { should be_file }
    its(:content) { should match %r{[Bootchart]} }
    its(:content) { should match %r{Output=/run/log} }
  end
end
