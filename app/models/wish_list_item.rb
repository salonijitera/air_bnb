class WishListItem < ApplicationRecord
  belongs_to :wish_list,
    foreign_key: :wish_list_id,
    class_name: 'WishList'
  belongs_to :property,
    foreign_key: :property_id,
    class_name: 'Property'
  validates :wish_list_id, :property_id, presence: true, numericality: { only_integer: true }
end
