require 'spec_helper'

describe 'Vconsole' do
  describe file('/etc/vconsole.conf') do
    it { should be_file }
    its(:content) { should match /KEYMAP="us"/ }
  end
end
