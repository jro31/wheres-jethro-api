shared_context 'login' do
  let(:email) { 'user@email.com' }
  let(:password) { 'password' }
  let!(:current_user) { create(:user, id: 1, email: email, password: password) }
  before { post '/api/v1/sessions', params: { user: { email: email, password: password } } }
end

shared_context 'login_imposter' do
  let(:email) { 'user@email.com' }
  let(:password) { 'password' }
  let!(:current_user) { create(:user, id: 2, email: email, password: password) }
  before { post '/api/v1/sessions', params: { user: { email: email, password: password } } }
end
