module V1
  class EventsController < ApplicationController
    before_action :set_schedule
    before_action :set_event, only: %i[show update destroy]

    def index
      @events = Event.all

      render json: @events
    end

    def create
      @event = @schedule.events.build(events_params)

      if @event.save
        render json: @event, status: :created
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end

    def show; end

    def update
      if @event.update(events_params)
        render json: @event
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @event.destroy
    end

    private

    def events_params
      params.require(:event).permit(:start_at, :end_at, :schedule_id, :room_id)
    end

    def set_schedule
      @schedule = Schedule.find(params[:schedule_id])
    end

    def set_event
      @event = @schedule.events.find(params[:id])
    end
  end
end
