require 'spec_helper'

describe 'Tmpfile' do
  describe file('/etc/tmpfiles.d/my-app.conf') do
    it { should be_file }
    its(:content) { should match %r{f /tmp/my-app - - - 10d -} }
  end
end
