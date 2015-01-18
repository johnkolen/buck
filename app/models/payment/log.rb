class Payment::Log < ActiveRecord::Base
  belongs_to :payment, :class_name=>"Payment::Payment"
end
