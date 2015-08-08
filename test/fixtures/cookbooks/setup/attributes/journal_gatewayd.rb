

default['systemd']['journal_gatewayd'].tap do |jg|
  jg['listen_stream'] = '19532'

  jg['options'].tap do |o|
    o['cert'] = '/etc/pki/tls/certs/journal-gatewayd.cert'
    o['key'] = '/etc/pki/tls/private/journal-gatewayd.key'
  end
end
