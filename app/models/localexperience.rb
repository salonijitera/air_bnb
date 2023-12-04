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
  has_one_attached :image
end
