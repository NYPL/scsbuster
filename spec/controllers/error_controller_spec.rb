require "rails_helper"

RSpec.describe ErrorController, :type => :controller do
  describe "GET #error" do
    context "when the query of type is undefined" do
      before do
        get :error, params: { type: "" }
      end
      it "should render the default error message and instruction" do
        expect(assigns(:error_message)).to      eq('The service is not available now.')
        expect(assigns(:instruction)).to        eq({ message: 'Back to homepage', link: root_path })
      end
    end

    context "when the query of type is not listed in ErrorController" do
      before do
        get :error, params: { type: "not_listed_error" }
      end
      it "should render the default error message and instruction" do
        expect(assigns(:error_message)).to      eq('The service is not available now.')
        expect(assigns(:instruction)).to        eq({ message: 'Back to homepage', link: root_path })
      end
    end

    context "when the query of type is user_not_authorized" do
      before do
        get :error, params: { type: "user_not_authorized" }
      end
      it "should render the error message and instruction about an unauthorized user" do
        expect(assigns(:error_message)).to      eq('The user is not authorized.')
        expect(assigns(:instruction)).to        eq({ message: 'Log in with another account', link: authenticate_path })
      end
    end
  end
end
