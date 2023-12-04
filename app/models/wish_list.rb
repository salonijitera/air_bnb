# == Schema Information
#
# Table name: wish_lists
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string           not null
#  max_wishlist: integer
#
class WishList < ApplicationRecord
  has_many :wish_list_items, dependent: :destroy
  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :max_wishlist, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
