# Doing this in setup so users can make their own decision
# https://github.com/chef/chef/pull/3774
if File.exist?("/usr/bin/dnf")
  execute "dnf install -y yum" do
    not_if { File.exist?("/usr/bin/yum-deprecated") }
  end
end
