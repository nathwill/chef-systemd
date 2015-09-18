
systemd_binfmt_d 'DOSWin' do
  magic 'MZ'
  interpreter '/usr/bin/wine'
end
