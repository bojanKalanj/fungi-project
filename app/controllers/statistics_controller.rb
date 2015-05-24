require 'fungiorbis/statistics'
class StatisticsController < ApplicationController

  respond_to :js

  def show
    render json: Fungiorbis::Statistics.new(params[:id]).get
  end

end
