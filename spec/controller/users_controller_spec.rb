describe UsersController, type: :controller do
  describe '#create' do
    context 'when informed correct params' do
      let(:params) do
        {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          password: Faker::Internet.password,
          username: Faker::Internet.username
        }
      end

      # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
      # if I did not do that, in each expectation, I will need to access database
      it 'returns 200, with user and token, creating a new user' do
        post :create, params: params

        data = JSON.parse(response.body)
        user = User.find(data.dig('user', 'id'))
        decoded_token = JWT.decode(data['token'], nil, true, algorithms: ['RS512'], jwks: jwk_loader)

        expect(response.status).to eq 200

        expect(data['user']).to match(
          'id' => a_kind_of(Integer),
          'name' => params[:name],
          'email' => params[:email],
          'password_digest' => a_kind_of(String),
          'created_at' => a_kind_of(String),
          'updated_at' => a_kind_of(String)
        )

        expect(decoded_token.first).to match(
          'user_id' => data.dig('user', 'id')
        )

        expect(user.attributes.symbolize_keys).to include(
          name: params[:name],
          email: params[:email]
        )
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
    end
  end

  private

    def jwk_loader
      pub_key = OpenSSL::PKey::RSA.new File.read Rails.root.join('certs/public.key')
      jwk = JWT::JWK.new(pub_key)

      @jwk_loader = lambda do |options|
        @cached_keys = nil if options[:invalidate] # need to reload the keys
        @cached_keys ||= { keys: [jwk.export] }
      end
    end
end
