module V1
  class RoomsController < ApplicationController
    def index
      @rooms = Room.all

      render json: @rooms
    end
  end
end
