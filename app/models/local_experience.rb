class LocalExperience < ApplicationRecord
  validates :title, :description, :location, :price, :image, :status, presence: true
  def self.create_local_experience(params)
    local_experience = self.new(params)
    if local_experience.valid?
      if Location.exists?(params[:location])
        local_experience.save
        # Assuming that the image is being stored in a cloud storage like AWS S3 and the path is being saved in the database
        local_experience.image = store_image(params[:image])
        local_experience.save
        return { success: true, message: 'Local Experience created successfully', local_experience: local_experience }
      else
        return { success: false, message: 'Location does not exist' }
      end
    else
      return { success: false, message: local_experience.errors.full_messages }
    end
  end
  private
  def self.store_image(image)
    # Logic to store image in a secure location and return the path
  end
end
