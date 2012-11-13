['3.0', '3.1', '3.2'].each do |version|
  appraise "rails.#{version}" do
    gem "actionpack", "~>#{version}.0"
    gem "rake"
    gem "appraisal"
    gem "rspec"
  end
end
