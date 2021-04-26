describe StatusController, type: :controller do
  context 'when called status without any authorization' do
    before { get :show }

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns body with success' do
      expect(response.body).to eq('{"success":true}')
    end
  end
end
