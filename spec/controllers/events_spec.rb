require 'rails_helper'

RSpec.describe V1::EventsController, type: :controller do
  fixtures :schedules

  describe 'GET /index' do
    it 'Should return all events' do
      get :index, params: { schedule_id: schedules(:getninjas).id }

      expect(response).to have_http_status(200)
    end
  end
end
