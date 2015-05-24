class SystematicsController < ApplicationController

  respond_to :js

  def show
    render json: Species.pluck(params[:id]).uniq.sort
  end

end
