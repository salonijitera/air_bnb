class PremiumListing < ApplicationRecord
  belongs_to :user
  validates :title, :description, :price, :user_id, :status, :posted_date, presence: true
  validates :title, presence: { message: "The title is required." }
  validates :description, presence: { message: "The description is required." }
  validates :price, numericality: { message: "The price must be a number." }
  validates :user_id, numericality: { only_integer: true, message: "The user_id is not valid." }
  validates :status, inclusion: { in: %w(active inactive), message: "The status is not valid." }
  validate :posted_date_is_date?
  private
  def posted_date_is_date?
    errors.add(:posted_date, 'The posted_date is not a valid date.') unless posted_date.is_a?(Date)
  end
end
