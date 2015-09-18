require 'spec_helper'

describe 'SystemdBinfmtD' do
  describe file('/etc/binfmt.d/DOSWin.conf') do
    its(:content) { should match Regexp.new(':DOSWin:M::MZ::/usr/bin/wine:') }
  end
end
