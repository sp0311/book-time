class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :thoughts, length: { maximum: 400 }
  validate  :picture_size

  def feed_comment(book_id)
    Comment.where("book_id = ?", book_id)
  end

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "：5MBより大きい画像はアップロードできません。")
    end
  end
end
