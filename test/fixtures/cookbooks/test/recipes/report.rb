#
# Simple idempotency report
#

modified = []

Chef.event_handler do
  on :run_completed do
    modified.each do |mod|
      puts "MODIFIED: #{mod}"
    end
  end
end

Chef.event_handler do
  on :resource_updated do |resource, action|
    modified << { resource: resource.to_s, action: action }
  end
end
