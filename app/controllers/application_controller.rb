class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    render json: { errors: { not_found: ['Registro não encontrado'] } }, status: :not_found
  end
end
