module Payment::Processor
  def self.new kind
    classname = "Payment::#{kind.to_s.classify}"
    eval(classname).new
  end
end
