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
      # FIXME: remove assertion of json token
      it 'returns 200, with user and token, creating a new user' do
        post :create, params: params

        data = parsed_body(response)
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

    context 'when some information is invalid' do
      before { post :create, params: {} }

      it 'returns http status of a bad request' do
        expect(response.status).to eq 400
      end

      it 'returns error information' do
        expect(parsed_body(response).fetch('error')).to eq('password' => ["can't be blank"])
      end
    end
  end

  describe '#login' do
    let(:params) do
      {
        email: 'sampleuser@provider.com',
        password: 'test'
      }
    end

    context 'when correct email and password is informed' do
      before { post :login, params: params }

      it 'returns json token' do
        expect(parsed_body(response).fetch('token')).not_to be_nil
      end

      it 'returns user' do
        expect(parsed_body(response).fetch('user')).to match(
          'id' => a_kind_of(Integer), 'name' => a_kind_of(String),
          'email' => params[:email], 'password_digest' => a_kind_of(String),
          'created_at' => a_kind_of(String), 'updated_at' => a_kind_of(String)
        )
      end

      it 'returns status 200' do
        expect(response.status).to eq 200
      end
    end

    context 'when password is incorrect' do
      before { post :login, params: params.merge(password: 'incorrect') }

      it 'informs error' do
        expect(parsed_body(response).fetch('error')).to eq('Invalid email or password')
      end

      it 'returns http unauthorized' do
        expect(response.status).to eq(401)
      end
    end

    context 'when email is incorrect' do
      before { post :login, params: params.merge(email: 'incorrect') }

      it 'informs error' do
        expect(parsed_body(response).fetch('error')).to eq('Invalid email or password')
      end

      it 'returns http unauthorized' do
        expect(response.status).to eq(401)
      end
    end

    # rubocop:disable RSpec/NestedGroups
    describe '#auto_login' do
      before do
        request.headers['Authorization'] = "bearer #{token}"
        request.headers['Content-Type'] = 'application/json'

        post :auto_login, params: {}
      end

      context 'when token is correct' do
        let(:token) { 'eyJrdHkiOiJSU0EiLCJuIjoiN3J2ZUZ0VW9IQVgyZzVNc0hDaTJCQmhZTTI4eURMTzhCYkN1Smc5dXZLS0FyY0pPQng2aWotcXVCdjBLWmE3VVJqUkt5TjQ5b2NMRGNpZEwzV0xjUk1LQlJBR2RPM3Nod3NTMzJYTjh4WEp0aGNvMlJSbG1EMjZVSTl6TTlSNjNGemtMeVhHQ2lyVG12OHlnVXV0am5CSU8zRHdpVHFyeGl6blItUnMwX0dfcVhUd0lGWUZNWGxZbkpZc3dwSy01RWdZTERxQlBoZHRsWUR5Vm1qYWU5TXdWbGxXaXNVODhVZ09aZ2JVVnFRWkt4OUFRSEpJdjFja0VhcDItZ3lCTWcxZDVFN1I5SldsbUhtcVR4VE9aeU9CeHZuejVwTVd6U2lwbHRlT3dmTWREX0pzYVR2aV93LTNHcjVZT3dLR3ZIOFV5b291dm13UUw4V0Y5ZFNmZjFFcXh6eFE5aGZDSDBiNGRQSTdPZVdnUG92YXk5Szk3OWVDMTdXNlo5d3dnSEc0eXN5NC1sbThMT1B1NzdQeDlhcE1UODBrbzllanhnb3JKLU5haEVDdXloM1hHajM3Rzlpdi1IWkFpaDczRHp0a0E5azdZYlNLWDRxS1gwdHNuNFdEQ0I4eTI1SWx6SnV4NGR5aS1mcVJQb1Jaa2hrcVVPc0F2dDB5NHoxRmlDZzQ2b3BqSnRFN1VuamFHQmhsUzVtSjVuNXRwS1djSHBUUDNRUUkwaXRjdFROY3hnQzRRc1oxNW9yNlBIZ2gtd3U2TTU5dlUyOGVTWWRITVphNEpNbzBMTjBVZW5DclBPT0kwcURrNzlRLUlSZ0tSQlo0c21wQ0VFSV8zN0FmMzFQUHdKRTZjbDJxWDZJVzlub0ZJZFNRdEkzcFJELVhnOHk2bG1EVnljWHMiLCJlIjoiQVFBQiIsImtpZCI6ImEwYmMyNzU1ZTRlNjY4YTc0MTllZWU3MTQ3ZTVlZjNiOTBhNDY3ZGNmYzBlNTY1YTI4OGQ3MGYzMjg5ZTc4YzkiLCJhbGciOiJSUzUxMiJ9.eyJ1c2VyX2lkIjowfQ.fykJakysw3oftF-gRZSm0pgrFpyL18eINFAa1-wJ5G3jk4NG38LIQcOknNuTRmgrd0q7cBVnNHfNR1LqzHfQfGtyomVQBTStiGAhGIzTxbiEoVDd9DJS5wwBaLTGH4stdvBSnE3DQMI_G0AnnQ0-96TL0vQlF6e4arEPyp_IXx22BlWhjEyjAnq5OExQGNnepnmfbpzC2Y29JsvDuI_FsqJ52VZvRGci_Tljj2rw6fwH3KvarIcfPF6MeDQ5sPTolSIDmEvBzd7wIWu8cu9g5zgwWJCTzUc1CAd9uYBmK_EgCMeJPIdy3eFDLS86vGNa_si9uCb3KafszpZNfUBbWQ_X5e6-_A6EGV0BePN9kE2gsAoafo-9R5IN1TBVB7nKd98jEFsQUYTVNPV98MLcXgzjZYj33fYaIEpiGaK7PwvLrfrjbgU2l9FnNVIUw_68oeYLa4BthStMCG3o9ttwxrXkmhINJxCJ5xUdP0uwdICt_oJJL02p9qQKWTI806nigVx1wMKkQyUmeom9BvFoG-ST_Sbw0e5YkUipbz0eSJMGsxPppoW5lH1kTgWj9xbMxuW0S75gnCtMbkauCo_iCC0Q6WDbBs29Xxryh1sOWmYqKzldbXadk1QTmWyEah57HeV2kZfXTUq1osxDeyHqv7BWs9kHc_EyM7E6vRqJpGU' }

        it 'returns success status' do
          expect(response.status).to eq 200
        end

        it 'returns user' do
          expect(parsed_body(response)).to match(
            'id' => a_kind_of(Integer), 'name' => a_kind_of(String),
            'email' => params[:email], 'password_digest' => a_kind_of(String),
            'created_at' => a_kind_of(String), 'updated_at' => a_kind_of(String)
          )
        end
      end

      context 'when token is incorrect' do
        let(:token) { 'BAD TOKEN' }

        it 'returns http unauthorized status' do
          expect(response.status).to eq 401
        end

        it 'return message informing about token' do
          expect(parsed_body(response).fetch('error')).to eq('The token is not valid')
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups
  end

  private

    def parsed_body(response)
      JSON.parse(response&.body)
    rescue JSON::ParserError
      {}
    end

    # FIXME: remove from here this assertion
    def jwk_loader
      pub_key = OpenSSL::PKey::RSA.new File.read Rails.root.join('certs/public.key')
      jwk = JWT::JWK.new(pub_key)

      @jwk_loader = lambda do |options|
        @cached_keys = nil if options[:invalidate] # need to reload the keys
        @cached_keys ||= { keys: [jwk.export] }
      end
    end
end
