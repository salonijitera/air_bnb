class PremiumListing < ApplicationRecord
  belongs_to :user
  validates :listing_name, :listing_status, :title, :description, :price, :status, :posted_date, :user_id, :listing_date, presence: true
  validates :listing_name, presence: { message: "The listing name is required." }
  validates :listing_status, inclusion: { in: %w(active inactive), message: "The listing status is not valid." }
  validates :title, presence: { message: "The title is required." }
  validates :description, presence: { message: "The description is required." }
  validates :price, numericality: { message: "The price must be a number." }
  validates :user_id, numericality: { only_integer: true, message: "The user_id is not valid." }
  validates :status, inclusion: { in: %w(active inactive), message: "The status is not valid." }
  validate :posted_date_is_date?
  validate :listing_date_is_date?
  private
  def posted_date_is_date?
    errors.add(:posted_date, 'The posted_date is not a valid date.') unless posted_date.is_a?(Date)
  end
  def listing_date_is_date?
    errors.add(:listing_date, 'The listing_date is not valid date.') unless listing_date.is_a?(Date)
  end
end
