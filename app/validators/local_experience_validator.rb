class LocalExperienceValidator
  def validate_update(id, title, description, location, price, image, status)
    errors = []
    if id.blank? || !id.is_a?(Numeric) || id < 0
      errors << "ID must be a positive number"
    end
    if title.blank?
      errors << "Title can't be blank"
    end
    if description.blank?
      errors << "Description can't be blank"
    end
    if location.blank?
      errors << "Location can't be blank"
    end
    if price.blank? || !price.is_a?(Numeric) || price < 0
      errors << "Price must be a positive number"
    end
    if image.blank?
      errors << "Image can't be blank"
    end
    if status.blank? || !['active', 'inactive'].include?(status)
      errors << "Status must be either 'active' or 'inactive'"
    end
    if errors.empty?
      return { success: true, message: 'Data is valid' }
    else
      return { success: false, message: 'Data is invalid', errors: errors }
    end
  end
end
