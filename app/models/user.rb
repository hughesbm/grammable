class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :grams, dependent: :destroy
  has_many :comments, dependent: :destroy

  def email_local_part
    return self.email.split('@')[0]
  end

  def email_domain
    return '@' + self.email.split('@')[1]
  end
end
