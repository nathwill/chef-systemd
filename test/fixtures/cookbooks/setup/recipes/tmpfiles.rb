
systemd_tmpfile 'my-app' do
  path '/tmp/my-app'
  age '10d'
  type 'f'
end
