resource_name :systemd_machine
provides :systemd_machine

property :uid, [String, Integer]
property :environment, Hash
property :signal, [String, Integer]
property :kill_who, String
property :bind, String

default_action :start

action :start do

end

action :enable do

end

action :disable do

end

action :poweroff do

end

action :terminate do

end

action :kill do

end

action :bind do

end
