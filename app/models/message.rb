class Message < ActiveRecord::Base
  belongs_to :user

  def self.current n=5
    includes(:user).order("created_at DESC").limit(n).reverse
  end
end
