class ErrorController < ApplicationController
  # If we want to get the access to URL Helpers outside of the instance methods,
  # we have to include URL helpers in the class
  route_url_helpers = Rails.application.routes.url_helpers

  # Set the constants for different error types
  ERROR_DEFAULT = {
    message: 'The service is not available now.',
    instruction_text: 'Back to homepage',
    instruction_link: route_url_helpers.root_path
  }
  ERROR_AUTHENTICATION_FAILED = {
    message: 'The authentication failed.',
    instruction_text: 'Back to homepage',
    instruction_link: route_url_helpers.root_path
  }
  ERROR_NOT_AUTHORIZED = {
    message: 'The user is not authorized.',
    instruction_text: 'Log in with another account',
    instruction_link: route_url_helpers.authenticate_path
  }

  # Render the error page based on the error type
  def error
    # Tell the view this is an error page so the navigation list is not needed
    @is_error_page = true
    # the error type that is passed from the query of the URL
    current_error_type = params[:type].to_s || ''

    errors_by_type = {
      user_not_authorized: ERROR_NOT_AUTHORIZED,
      authentication_failed: ERROR_AUTHENTICATION_FAILED,
    }

    # If the error type from the query is not indicated or listed as one of the error constants,
    # then use the default setting
    errors_by_type.default = ERROR_DEFAULT

    # Assign the error instance variable with the values of the chosen error constant
    @error = errors_by_type[:"#{current_error_type}"]
  end
end
