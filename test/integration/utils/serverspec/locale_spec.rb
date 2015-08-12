require 'spec_helper'

describe 'Locale' do
  describe file('/etc/locale.conf') do
    it { should be_file }
    its(:content) { should match /LANG=en_US.UTF-8/ }
  end
end
