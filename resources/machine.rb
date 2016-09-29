resource_name :systemd_machine
provides :systemd_machine

property :uid, [String, Integer]
property :environment, Hash
property :signal, [String, Integer]
property :kill_who, String
property :bind, String

default_action :start

action :start do
  # do stuff
end

action :enable do
  # do stuff
end

action :disable do
  # do stuff
end

action :poweroff do
  # do stuff
end

action :terminate do
  # do stuff
end

action :kill do
  # do stuff
end

action :bind do
  # do stuff
end
