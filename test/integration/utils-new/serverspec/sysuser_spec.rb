require 'spec_helper'

describe "Sysuser" do
  describe file ('/etc/sysusers.d/_testuser.conf') do
    it { should be_file }
    its(:content) { should match /test/ }
  end

  describe user('_testuser') do
    it { should exist }
    it { should have_uid 65_530 }
    it { should have_home_directory '/var/lib/test' }
  end
end
