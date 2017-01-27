require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  include_context 'user signed in'

  let(:body) { JSON.parse(response.body) }

  describe '#show' do
    let!(:task) { create(:task, user: user) }

    before { get :show, { user_id: user.id, id: task.id } }

    it 'is successful' do
      expect(response).to have_http_status(:success)
    end
  end
end
