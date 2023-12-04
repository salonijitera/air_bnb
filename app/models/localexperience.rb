# == Schema Information
#
# Table name: localexperiences
#
#  id          :bigint           not null, primary key
#  title       :string
#  description :text
#  location    :string
#  price       :decimal
#  date        :date
#  image       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Localexperience < ApplicationRecord
  validates :title, :description, :location, :price, :date, presence: true
  validates :title, length: { maximum: 200, message: "You cannot input more 200 characters." }
  validates :description, length: { maximum: 10000, message: "You cannot input more 10000 characters." }
  validates :location, length: { maximum: 200, message: "You cannot input more 200 characters." }
  validates :price, numericality: { greater_than_or_equal_to: 0, message: "Wrong format." }
  validate :date_cannot_be_in_the_past, :date_is_date?, :image_is_file?
  has_one_attached :image
  private
  def date_cannot_be_in_the_past
    if date.present? && date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end
  def date_is_date?
    errors.add(:date, 'Wrong date format.') unless date.is_a?(Date)
  end
  def image_is_file?
    errors.add(:image, 'Wrong file format.') unless image.attached?
  end
end
