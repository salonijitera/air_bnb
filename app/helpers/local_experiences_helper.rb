module LocalExperiencesHelper
  def update_local_experience_params(params)
    params.require(:local_experience).permit(:id, :title, :description, :location, :price, :image, :status)
  end
end
