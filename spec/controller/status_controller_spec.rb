describe StatusController, type: :controller do
  context 'when called status without any authorization' do
    it 'returns 200 with success' do
      get :show

      expect(response.status).to eq(200)
      expect(response.body).to eq('{"success":true}')
    end
  end
end
