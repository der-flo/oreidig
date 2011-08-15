module Jqm

  def self.source_files
    Jqm::Stylesheet.instance_eval vendor_file
    Dir[File.join(Rails.root,"app/assets/jqm/*.rb")].each do |file|
      Jqm::Stylesheet.instance_eval File.read(file)
    end
  end

  def self.vendor_file
    File.read(File.join(File.dirname(__FILE__), "../app/assets/jqm/vendor.rb"))
  end

end


# Monkey patching YEEEEAAAH!
class Hash
  def deep_merge(hash)
    target = dup
    hash.keys.each do |key|
      if hash[key].is_a? Hash and self[key].is_a? Hash
        target[key] = target[key].deep_merge(hash[key])
        next
      end
      target[key] = hash[key]
    end
    target
  end
end


if Rails.env == "development"
  unloadable Jqm
end
