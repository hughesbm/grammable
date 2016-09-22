class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :gram
  
  validates :message, presence: true, length: { minimum: 5, maximum: 200 }
end
