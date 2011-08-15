class Jqm::Stylesheet

  cattr_accessor :contexts, :methods, :actual_context

  self.methods = []
  self.contexts = {}
  self.actual_context = :vendor

  attr_accessor :data

  def self.context name, &block
    instance = new
    instance.extends :vendor, (name == :vendor)
    instance.instance_eval &block
    self.contexts.store(name, instance.data)
  end

  def context name, &blck
    self.class.context name, &blck
  end

  def initialize
    self.data = {}
    self.class.contexts = {} if self.class.contexts.nil?
  end

  def extends context, initial = false
    unless initial
      self.data = self.data.deep_merge(self.class.contexts.fetch(context))
    end
  end

  def method_missing m, *values, &blck
    if blck
      instance = self.class.new
      instance.instance_eval(&blck)
      self.class.methods << m
      if self.data.key? m
        instance.data = instance.data.deep_merge(self.data.fetch(m))
      end
      self.data.store(m.to_sym, instance.data)
    else
      m = m.to_s.gsub("_", "-")
      self.data.store(m.to_sym, values.first.to_s)
    end
  end

  # Helper for unspellable_methods like "split-icon"
  def h method, value, &blck
    send method, value, &blck
  end


end

