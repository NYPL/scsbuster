require 'rails_helper'

describe ErrorHelper, type: :helper do
  describe '#error_type_object' do
    context 'when the query of type is undefined' do
      it 'should render the default error message and instruction' do
        expect(helper.error_type_object[:message]).to eq('The service is not available now.')
        expect(helper.error_type_object[:instruction_text]).to eq('Back to homepage')
        expect(helper.error_type_object[:instruction_link]).to eq(root_path)
      end
    end

    context 'when the query of type is not listed in ErrorController' do
      it 'should render the default error message and instruction' do
        helper.params[:type] = 'not_listed_error'

        expect(helper.error_type_object[:message]).to eq('The service is not available now.')
        expect(helper.error_type_object[:instruction_text]).to eq('Back to homepage')
        expect(helper.error_type_object[:instruction_link]).to eq(root_path)
      end
    end

    context 'when the query of type is user_not_authorized' do
      it 'should render the error message and instruction about an unauthorized user' do
        helper.params[:type] = 'user_not_authorized'

        expect(helper.error_type_object[:message]).to eq('The user is not authorized.')
        expect(helper.error_type_object[:instruction_text]).to eq('Log in with another account')
        expect(helper.error_type_object[:instruction_link]).to eq(authenticate_path)
      end
    end

    context 'when the query of type is authentication_failed' do
      it 'should render the error message and instruction about failed authentication' do
        helper.params[:type] = 'authentication_failed'

        expect(helper.error_type_object[:message]).to eq('The authentication failed.')
        expect(helper.error_type_object[:instruction_text]).to eq('Back to homepage')
        expect(helper.error_type_object[:instruction_link]).to eq(root_path)
      end
    end
  end
end
