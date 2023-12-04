# == Schema Information
#
# Table name: wish_lists
#
#  id              :bigint           not null, primary key
#  name            :string
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class WishList < ApplicationRecord
  belongs_to :user
  validates :name, presence: { message: "The name is required." }
  validates :user_id, numericality: { only_integer: true, message: "Wrong format" }
  has_many :wish_list_items,
    foreign_key: :wish_list_id,
    class_name: 'WishListItem'
  def shareWishList(id, email)
    wish_list = WishList.find(id)
    return { status: 400, message: 'Wish list not found' } unless wish_list
    # Assuming we have a Mailer set up
    begin
      WishListMailer.with(wish_list: wish_list, email: email).share_wish_list.deliver_now
      return { status: 200, message: 'Wish list was successfully shared.' }
    rescue => e
      puts "Failed to send email: #{e.message}"
      return { status: 500, message: 'Failed to send email' }
    end
  end
end
