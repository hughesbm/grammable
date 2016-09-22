class Gram < ApplicationRecord
  belongs_to :user
  has_many :comments

  mount_uploader :picture, PictureUploader
  
  validates :message, presence: true, length: { minimum: 5, maximum: 200 }
  validates :picture, presence: true
end
