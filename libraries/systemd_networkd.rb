require_relative 'systemd_networkd_match'
require_relative 'systemd_networkd_link'

module Systemd
  module Networkd
    OPTIONS ||= Systemd::Networkd::Match | Systemd::Networkd::Link
  end
end
