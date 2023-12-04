# == Schema Information
#
# Table name: wish_list_items
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  wish_list_id    :bigint
#  max_items       :integer
#  min_items       :integer
#
class WishListItem < ApplicationRecord
  belongs_to :wish_list
  validates :max_items, numericality: { greater_than: 0, less_than: 10, message: "Max items should be between 1 and 9." }
  validates :min_items, numericality: { greater_than: 0, less_than: 5, message: "Min items should be between 1 and 4." }, presence: true
end
