# http://www.freedesktop.org/software/systemd/man/bootchart.conf.html
module Systemd
  module Bootchart
    OPTIONS ||= %w(
      Samples
      Frequency
      Relative
      Filter
      Output
      Init
      PlotMemoryUsage
      PlotEntropyGraph
      ScaleX
      ScaleY
      ControlGroup
    )
  end
end
