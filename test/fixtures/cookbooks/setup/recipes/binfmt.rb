
systemd_binfmt 'DOSWin' do
  magic 'MZ'
  interpreter '/usr/bin/wine'
end
