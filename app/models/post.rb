class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, -> { ordering }, dependent: :destroy

  scope :ordering, -> { order(created_at: :desc) }

  validates :title, presence: true, length: {in: 2..255}
  validates :body, presence: true
  validate :check_count
  def check_count
    if user.posts.where('created_at > ?', 1.day.ago).count >= 5
      errors.add(:base, :check_err)
    end
  end
  def edit_by?(current_user)
    current_user == user || current_user&.admin?
  end
end
