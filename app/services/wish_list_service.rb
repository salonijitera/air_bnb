class WishListService
  def initialize(user_id, name)
    @user_id = user_id
    @name = name
  end
  def create_wish_list
    begin
      user = User.find(@user_id)
      wish_list = user.wish_lists.new(name: @name)
      if wish_list.save
        return { status: 200, wish_list: wish_list }
      else
        return { status: 422, error: wish_list.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound
      return { status: 400, error: "This user is not found" }
    rescue Exception => e
      return { status: 500, error: e.message }
    end
  end
  def add_property_to_wish_list(wish_list_id, property_id)
    begin
      wish_list = WishList.find(wish_list_id)
      property = Property.find(property_id)
      if wish_list.wish_list_items.find_by(property_id: property.id)
        raise "Property is already in the wish list"
      end
      wish_list_item = wish_list.wish_list_items.create(property: property)
      if wish_list_item.persisted?
        return { status: 200, wish_list: wish_list.reload }
      else
        return { status: 422, error: wish_list_item.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound
      return { status: 400, error: "Wish list or property not found" }
    rescue Exception => e
      return { status: 500, error: e.message }
    end
  end
  def share_wish_list(wish_list_id, user_id)
    begin
      wish_list = WishList.find(wish_list_id)
      user = User.find(user_id)
      raise "Wish list or user not found" unless wish_list && user
      WishListMailer.share(wish_list, user.email).deliver_now
      return { status: 200, message: "Wish list was successfully shared." }
    rescue ActiveRecord::RecordNotFound
      return { status: 400, error: "Wish list or user not found" }
    rescue Exception => e
      return { status: 500, error: e.message }
    end
  end
end
