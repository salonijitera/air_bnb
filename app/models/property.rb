class Property < ApplicationRecord
  has_many :wish_list_items,
    foreign_key: :property_id,
    class_name: 'WishListItem'
  validates :name, :price, :location, presence: true
end
