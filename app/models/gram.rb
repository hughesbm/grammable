class Gram < ApplicationRecord
  belongs_to :user
  validates :message, presence: true, length: { minimum: 5, maximum: 200 }
end
