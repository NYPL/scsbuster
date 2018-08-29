require "rails_helper"

describe User do

  before do
    # the payload of the mock_access_token_authorized:
    # {
    #   "sub": "whale@example.com",
    #   "iat": 1535403447,
    #   "exp": 1535407047,
    #   "auth_time": 1535403446,
    #   "email": "whale@example.com",
    #   "email_verified": true,
    #   "name": "Whale Blue",
    #   "given_name": "Whale",
    #   "family_name": "Blue"
    # }
    @mock_access_token_authorized = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ3aGFsZUBleGFtcGxlLmNvbSIsImlhdCI6MTUzNTQwMzQ0NywiZXhwIjoxNTM1NDc4MDYzLCJhdXRoX3RpbWUiOjE1MzU0MDM0NDYsImVtYWlsIjoid2hhbGVAZXhhbXBsZS5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6IldoYWxlIEJsdWUiLCJnaXZlbl9uYW1lIjoiV2hhbGUiLCJmYW1pbHlfbmFtZSI6IkJsdWUiLCJqdGkiOiI5ZGM2MGVhOS04ZDQ1LTRlNTctYTc4Yy00NGI0NWU3OTVkMzQifQ.a3jacg15drcs0aFmKrIqNMBe5Ko2svbUYPHleflhAng"

    # the payload of the mock_access_token_not_authorized:
    # {
    #   "sub": "swordfish@example.com",
    #   "iat": 1535403447,
    #   "exp": 1535407047,
    #   "auth_time": 1535403446,
    #   "email": "swordfish@example.com",
    #   "email_verified": true,
    #   "name": "Swordfish Coral",
    #   "given_name": "Swordfish",
    #   "family_name": "Coral"
    # }
    @mock_access_token_not_authorized = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzd29yZGZpc2hAZXhhbXBsZS5jb20iLCJpYXQiOjE1MzU0MDM0NDcsImV4cCI6MTUzNTQ3Nzk5MiwiYXV0aF90aW1lIjoxNTM1NDAzNDQ2LCJlbWFpbCI6InN3b3JkZmlzaEBleGFtcGxlLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoiU3dvcmRmaXNoIENvcmFsIiwiZ2l2ZW5fbmFtZSI6IlN3b3JkZmlzaCIsImZhbWlseV9uYW1lIjoiQ29yYWwiLCJqdGkiOiI5ODVhMDM1ZC04NGRiLTQzMTgtODMyMS0yNDhiNGRlYjQxMzAifQ.-kG0WzUwruhdDmbeWa0oTYdxLM17as-5DvfKq8Y8QEA"
  end

  describe "get_email_address" do
    it "should return nil as the user's email address if no access token is offered" do
      user_email = User.new(access_token: nil).get_email_address

      expect(user_email).to be_nil
    end

    it "should decode and get the user's email address if there is a valid access token" do
      user_email = User.new(access_token: @mock_access_token_authorized).get_email_address

      expect(user_email).to eq("whale@example.com")
    end
  end

  describe "is_authorized?" do
    it "should check if the user's email address on the authorized list and return the result" do
      mock_authorized_list = ['whale@example.com', 'dolphin@example.com', 'lobster@example.com']
      # Stub the method, get_authorized_list, to return mock_authorized_list
      User.stub(:get_authorized_list).and_return(mock_authorized_list)

      expect(User.new(access_token: @mock_access_token_authorized).is_authorized?).to               eq(true)
      expect(User.new(access_token: @mock_access_token_not_authorized).is_authorized?).to           eq(false)
    end
  end
end
