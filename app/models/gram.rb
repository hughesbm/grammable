class Gram < ApplicationRecord
  validates :message, presence: true, length: { minimum: 5, maximum: 200 }
end
