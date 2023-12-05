class LocalExperiencesJob < ApplicationJob
  queue_as :default
  def perform(id, title, description, location, price, image, status)
    LocalExperiencesService.new.update_local_experience(id, title, description, location, price, image, status)
  rescue => e
    # Log the error and re-raise it
    Rails.logger.error("Failed to update Local Experience: #{e.message}")
    raise
  end
end
