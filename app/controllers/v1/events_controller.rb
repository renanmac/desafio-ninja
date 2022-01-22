module V1
  class EventsController < ApplicationController
    before_action :set_schedule
    before_action :set_event, only: %i[show update destroy]
    before_action :date_params_validation, only: %i[create update]

    def index
      @events = Event.all

      render json: @events
    end

    def create
      @event = @schedule.events.build(events_params)

      if @event.save
        render json: @event, status: :created
      else
        render json: { errors: @event.errors }, status: :unprocessable_entity
      end
    end

    def show
      render json: @event
    end

    def update
      if @event.update(events_params)
        render json: @event
      else
        render json: { errors: @event.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      @event.destroy
    end

    private

    def date_params_validation
      events_params.slice(:start_at, :end_at).each { |_, date| Time.zone.parse(date) }
    rescue ArgumentError
      render json: { errors: { date: ['Data informada está em um formato inválido'] } }, status: :bad_request
    end

    def events_params
      params.require(:event).permit(:start_at, :end_at, :owner_email, :title, :schedule_id, :room_id)
    end

    def set_schedule
      @schedule = Schedule.find(params[:schedule_id])
    end

    def set_event
      @event = @schedule.events.find(params[:id])
    end
  end
end
