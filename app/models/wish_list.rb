class WishList < ApplicationRecord
  belongs_to :user
  has_many :wish_list_items, foreign_key: :wish_list_id, class_name: 'WishListItem', dependent: :destroy
  has_many :collaborators, dependent: :destroy
  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :max_wishlist, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  def add_collaborator(user_id)
    user = User.find_by_id(user_id)
    return { error: 'User not found' } unless user
    if self.collaborators.exists?(user_id: user_id)
      return { error: 'User is already a collaborator' }
    end
    collaborator = self.collaborators.build(user_id: user_id)
    if collaborator.save
      { success: 'User added as a collaborator', wish_list: self.reload }
    else
      { error: collaborator.errors.full_messages.join(', ') }
    end
  end
end
