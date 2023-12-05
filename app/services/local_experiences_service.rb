class LocalExperiencesService
  def initialize(id)
    raise 'Wrong format' unless id.is_a? Integer
    @local_experience = Localexperience.find_by(id: id)
    raise 'This local experience is not found' unless @local_experience
  end
  def update_local_experience(title, description, location, price, image, status)
    raise 'The title is required.' if title.blank?
    raise 'The description is required.' if description.blank?
    raise 'The location is required.' if location.blank?
    raise 'The price must be a number.' unless price.is_a?(Numeric)
    raise 'The status is not valid.' unless Localexperience.statuses.include?(status)
    raise 'The image is required.' if image.blank?
    validator = LocalExperienceValidator.new(title: title, description: description, location: location, price: price, image: image, status: status)
    raise validator.errors.full_messages.to_sentence unless validator.valid?
    @local_experience.update(title: title, description: description, location: location, price: price, image: image, status: status)
    if @local_experience.persisted?
      return {status: 200, local_experience: @local_experience}
    else
      raise 'Failed to update local experience'
    end
  end
end
