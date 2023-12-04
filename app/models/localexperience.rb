class Localexperience < ApplicationRecord
  validates :title, :description, :location, :price, :date, :image, presence: true
  validates :title, length: { maximum: 200, message: "You cannot input more 200 characters." }
  validates :description, length: { maximum: 10000, message: "You cannot input more 10000 characters." }
  validates :location, length: { maximum: 200, message: "You cannot input more 200 characters." }
  validates :price, numericality: { greater_than: 0, message: "Wrong format." }
  validate :date_is_date?
  validate :image_is_file?
  has_one_attached :image
  private
  def date_is_date?
    errors.add(:date, 'Wrong date format.') unless date.is_a?(Date)
  end
  def image_is_file?
    errors.add(:image, 'Wrong file format.') unless image.attached?
  end
end
