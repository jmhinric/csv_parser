shared_context 'user signed in' do
  let(:user) { create(:user) }
  before { sign_in(user) }
  after { sign_out(user ) }
end
