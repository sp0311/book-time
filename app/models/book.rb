class Book < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :thoughts, length: { maximum: 400 }
end
