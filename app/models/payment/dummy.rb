class Payment::Dummy < Payment::Payment
  def vendor
    "Dummy"
  end
  def initiate
    self.transaction do
      self.reload
      self.attempts += 1
      self.completed.save
    end
  end
  def process_response payload={}
    raise "Unexpected message from vendor" unless self.is_sent?
    if payload.has_key? "error"
      self.failed
    else
      self.completed
    end
    save
  end
end
