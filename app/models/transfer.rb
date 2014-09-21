class Transfer < ActiveRecord::Base
  validates :amount_cents, :presence=>true
  validates :user, :presence=>true
  validates :recipient, :presence=>true
  validates :note, :presence=>true

  belongs_to :user, :inverse_of=>:transfers
  belongs_to :recipient, :class_name=>"User", :inverse_of=>:received_transfers
  has_many :comments

  scope(:involving,
        ->(user){ where("user_id = ? OR recipient_id = ?", user.id, user.id) })

  def created_at_tz
    if created_at
      created_at.in_time_zone(user.time_zone)
    else
      nil
    end
  end

  def amount
    amount_cents / 100.0 if amount_cents
  end

  def amount= value
    if value
      self.amount_cents = (value.to_f * 100.0).to_i
    else
      self.amount_cents = nil
    end
  end

  def other_user u
    if user_id == u.id
      self.recipient
    else
      self.user
    end
  end
end
