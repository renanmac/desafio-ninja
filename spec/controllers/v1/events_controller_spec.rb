require 'rails_helper'

RSpec.describe V1::EventsController, type: :controller do
  fixtures :schedules
  fixtures :rooms

  describe 'GET #index' do
    it 'Should return all events' do
      get :index, params: { schedule_id: schedules(:getninjas).id }

      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    it 'Should create an event' do
      params = {
        schedule_id: schedules(:getninjas).id,
        event: {
          owner_email: 'ninja@mail.com',
          start_at: '01-12-2022 09:00',
          end_at: '01-12-2022 10:00',
          room_id: rooms(:subzero).id
        }
      }

      post :create, params: params

      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(201)
      expect(json_response['start_at']).to eq('2022-12-01T09:00:00.000-03:00')
      expect(json_response['end_at']).to eq('2022-12-01T10:00:00.000-03:00')
    end

    it 'Should not create event without required params' do
      params = {
        schedule_id: schedules(:getninjas).id,
        event: {
          start_at: '01-12-2022 09:00',
          end_at: '01-12-2022 10:00',
          room_id: rooms(:subzero).id
        }
      }

      post :create, params: params

      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(422)
      expect(json_response['errors']['owner_email'].first).to eq("can't be blank")
    end
  end

  describe 'PUT #update' do
    let(:event) {
      Event.create(
        start_at: '01-12-2022 09:00',
        end_at: '01-12-2022 10:00',
        owner_email: 'ninja@mail.com',
        schedule_id: schedules(:getninjas).id,
        room_id: rooms(:subzero).id
      )
    }

    it 'Should update an event' do
      params = {
        schedule_id: schedules(:getninjas).id,
        id: event.id,
        event: { owner_email: 'ninja2@mail.com' }
      }

      put :update, params: params

      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(json_response['owner_email']).to eq('ninja2@mail.com')
    end

    it 'Should not update event' do
      params = {
        schedule_id: schedules(:getninjas).id,
        id: event.id,
        event: { end_at: '02-12-2022 10:00' }
      }

      put :update, params: params

      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(422)
      expect(json_response['errors']['same_day'].first).to eq('As datas de início e fim do evento estão em dias diferentes')
    end

    it 'Should return an error because date is invalid' do
      params = {
        schedule_id: schedules(:getninjas).id,
        id: event.id,
        event: { end_at: '02-31-2022 10:00' }
      }

      put :update, params: params

      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(400)
      expect(json_response['errors']['date'].first).to eq('Data informada está em um formato inválido')
    end
  end

  describe 'DELETE #destroy' do
    it 'Should destroy an event' do
      event = Event.create(
        start_at: '01-12-2022 09:00',
        end_at: '01-12-2022 10:00',
        owner_email: 'ninja@mail.com',
        schedule_id: schedules(:getninjas).id,
        room_id: rooms(:subzero).id
      )

      params = {
        schedule_id: schedules(:getninjas).id,
        id: event.id
      }

      delete :destroy, params: params

      expect(response).to have_http_status(204)
    end

    it 'Should not destroy an event' do
      params = {
        schedule_id: schedules(:getninjas).id,
        id: '123'
      }

      delete :destroy, params: params

      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(404)
      expect(json_response['errors']['not_found'].first).to eq('Registro não encontrado')
    end
  end
end
