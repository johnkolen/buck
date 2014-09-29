class Comment < ActiveRecord::Base
  validates :transfer, :presence=>true
  validates :user, :presence=>true

  belongs_to :transfer
  belongs_to :user

  # Image
  has_attached_file(:image,
                    :styles=>{:medium=>"200x200>", :thumb=>"80x80>"},
                    :path=>"/comments/images/:id_:basename.:style.:extension",
                    :default_url=>":style/missing-image.png")
  validates_attachment_content_type :image, :content_type=>/\Aimage\/.*\Z/
end
