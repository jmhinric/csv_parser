# == Schema Information
#
# Table name: templates
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :string
#  user_id     :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe TemplatesController, type: :controller do
  include_context 'user signed in'

  let(:params) { { user_id: user.id } }
  let(:body) { JSON.parse(response.body) }

  describe '#show' do
    let!(:template) { create(:template, user: user) }

    before { get :show, params.merge(id: template.id) }

    it 'is successful' do
      expect(response).to have_http_status(:success)
    end
  end

  describe '#create' do
    let(:template_params) { params.merge(template: { name: 'Template Name', description: 'Template description' }) }
    let(:template) { Template.first }

    subject { post :create, template_params }

    it 'redirects to user_path' do
      expect(subject).to redirect_to(user_path(user))
    end

    it 'creates a template with proper attributes' do
      expect { subject }.to change { Template.count }.by 1
      expect(template.name).to eq('Template Name')
      expect(template.description).to eq('Template description')
    end
  end
end
