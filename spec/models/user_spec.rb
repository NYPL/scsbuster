require "rails_helper"

describe User do
  # the payload of the mock_access_token_authorized:
  # {
  #   "iss": "isso.nypl.org",
  #   "sub": "whale@example.com",
  #   "aud": "platform_admin",
  #   "iat": 1535403447,
  #   "exp": 1535407047,
  #   "auth_time": 1535403446,
  #   "scope": "openid login:staff offline_access",
  #   "email": "whale@example.com",
  #   "email_verified": true,
  #   "name": "Whale Blue",
  #   "given_name": "Whale",
  #   "family_name": "Blue"
  # }
  mock_access_token_authorized = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJpc3NvLm55cGwub3JnIiwic3ViIjoid2hhbGVAZXhhbXBsZS5jb20iLCJhdWQiOiJwbGF0Zm9ybV9hZG1pbiIsImlhdCI6MTUzNTQwMzQ0NywiZXhwIjoxNTM1NDA3NzI3LCJhdXRoX3RpbWUiOjE1MzU0MDM0NDYsInNjb3BlIjoib3BlbmlkIGxvZ2luOnN0YWZmIG9mZmxpbmVfYWNjZXNzIiwiZW1haWwiOiJ3aGFsZUBleGFtcGxlLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoiV2hhbGUgQmx1ZSIsImdpdmVuX25hbWUiOiJXaGFsZSIsImZhbWlseV9uYW1lIjoiQmx1ZSIsImp0aSI6IjUyNmY0MjQ2LWMyZDUtNDllOC04MTJlLTZjOTkzMmNhMmM5MiJ9.SyWeEdywfh1WUBQn8bL7KL3RuUKf_EUsmg4_sSjwaTg"

  # the payload of the mock_access_token_not_authorized:
  # {
  #   "iss": "isso.nypl.org",
  #   "sub": "swordfish@example.com",
  #   "aud": "platform_admin",
  #   "iat": 1535403447,
  #   "exp": 1535407047,
  #   "auth_time": 1535403446,
  #   "scope": "openid login:staff offline_access",
  #   "email": "swordfish@example.com",
  #   "email_verified": true,
  #   "name": "Whale Blue",
  #   "given_name": "Whale",
  #   "family_name": "Blue"
  # }
  mock_access_token_not_authorized = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJpc3NvLm55cGwub3JnIiwic3ViIjoic3dvcmRmaXNoQGV4YW1wbGUuY29tIiwiYXVkIjoicGxhdGZvcm1fYWRtaW4iLCJpYXQiOjE1MzU0MDM0NDcsImV4cCI6MTUzNTQ3NjE2NiwiYXV0aF90aW1lIjoxNTM1NDAzNDQ2LCJzY29wZSI6Im9wZW5pZCBsb2dpbjpzdGFmZiBvZmZsaW5lX2FjY2VzcyIsImVtYWlsIjoic3dvcmRmaXNoQGV4YW1wbGUuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5hbWUiOiJXaGFsZSBCbHVlIiwiZ2l2ZW5fbmFtZSI6IldoYWxlIiwiZmFtaWx5X25hbWUiOiJCbHVlIiwianRpIjoiMzQzNjBjNzItZDI0ZS00M2FlLThmY2MtMTQ1NmMwZTM2NzEzIn0.prCyre0UzxpbBna_Hih4wizPAADLb7WOlPmaMMzA5jQ"

  describe "get_email_address" do
    it "should return nil as the user's email address if no access token is offered" do
      user_email = User.new(access_token: nil).get_email_address

      expect(user_email).to eq(nil)
    end

    it "should decode and get the user's email address if there is a valid access token" do
      user_email = User.new(access_token: mock_access_token_authorized).get_email_address

      expect(user_email).to eq("whale@example.com")
    end
  end

  describe "is_authorized?" do
    it "should check if the user's email address on the authorized list and return the result" do
      mock_authorized_list = ['whale@example.com', 'dolphin@example.com', 'lobster@example.com']
      # Stub the method, get_authorized_list, to return mock_authorized_list
      User.stub(:get_authorized_list).and_return(mock_authorized_list)
      
      expect(User.new(access_token: mock_access_token_authorized).is_authorized?).to               eq(true)
      expect(User.new(access_token: mock_access_token_not_authorized).is_authorized?).to           eq(false)
    end
  end
end
