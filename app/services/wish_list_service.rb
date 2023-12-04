class WishListService
  def initialize(user_id, name)
    @user_id = user_id
    @name = name
  end
  def create_wish_list
    # ... existing code ...
  end
  def add_property_to_wish_list(wish_list_id, property_id)
    # ... existing code ...
  end
  def share_wish_list(wish_list_id, user_id)
    # ... existing code ...
  end
  def add_collaborator(wish_list_id, user_id)
    begin
      wish_list = WishList.find(wish_list_id)
      user = User.find(user_id)
      raise "Wish list or user not found" unless wish_list && user
      if wish_list.users.include?(user)
        return { status: 400, error: "User is already a collaborator" }
      end
      wish_list.users << user
      if wish_list.save
        WishListMailer.collaborator_added(wish_list, user.email).deliver_now
        return { status: 200, message: "User was successfully added as a collaborator.", wish_list: wish_list }
      else
        return { status: 422, error: wish_list.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound
      return { status: 400, error: "Wish list or user not found" }
    rescue Exception => e
      return { status: 500, error: e.message }
    end
  end
end
