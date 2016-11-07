# == Schema Information
#
# Table name: tasks
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :string
#  user_id     :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  include_context 'user signed in'

  let(:params) { { user_id: user.id } }
  let(:body) { JSON.parse(response.body) }

  describe '#show' do
    let!(:task) { create(:task, user: user) }

    before { get :show, params.merge(id: task.id) }

    it 'is successful' do
      expect(response).to have_http_status(:success)
    end
  end

  describe '#create' do
    let(:task_params) { params.merge(task: { name: 'Task Name', description: 'Task description' }) }
    let(:task) { Task.first }

    subject { post :create, task_params }

    it 'redirects to user_path' do
      expect(subject).to redirect_to(user_path(user))
    end

    it 'creates a task with proper attributes' do
      expect { subject }.to change { Task.count }.by 1
      expect(task.name).to eq('Task Name')
      expect(task.description).to eq('Task description')
    end
  end
end
