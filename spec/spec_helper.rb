support_scripts = Dir[File.expand_path("../support/**/*.rb", __FILE__)]
support_scripts.each do |support_script|
  require support_script
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "en_masse"
