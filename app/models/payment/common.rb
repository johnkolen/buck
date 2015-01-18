class Payment::Common < ActiveRecord::Base
  self.inheritance_column = :vendor_class
  STATES = {
    :start=> 0,
    :sent=>100,
    :timed_out=>130,
    :received=>200,
    :completed=>900,
    :failed=>999
  }
  @@state_str = {}
  STATES.each do |k,v|
    @@state_str[v] = k.to_s.sub('_',' ').capitalize
    define_method(k) do |*args|
      self.state = v - 1
      self.send("actual_#{k}", *args)
      self.state = v
      self
    end
  end
  def state_str
    @@state_str[@state]
  end
  def state_str= v
    raise "bad state #{v}" unless STATES[v.to_sym]
    @state = STATES[v.to_sym]
  end
end
