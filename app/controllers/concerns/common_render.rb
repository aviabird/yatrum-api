module CommonRender
  extend ActiveSupport::Concern
    #================ Function to Render Data =======================
    def render_data(data, status)
      render json: data, status: status, callback: params[:callback]
    end

    def render_error(message, status = :unprocessable_entity)
      render_data({ error: message }, status)
    end

    def render_success(data, status = :ok)
      if data.is_a? String
        render_data({ message: data }, status)
      else
        render_data(data, status)
      end
    end

    #=================================================================
end