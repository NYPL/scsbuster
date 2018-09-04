module ErrorHelper
  # _path & _url helpers are usually available in instance, not class scope.
  URL_HELPERS = Rails.application.routes.url_helpers

  # Set the constants for different error types
  ERROR_DEFAULT = {
    message: 'The service is not available now.',
    instruction_text: 'Back to homepage',
    instruction_link: URL_HELPERS.root_path
  }.freeze

  ERROR_AUTHENTICATION_FAILED = {
    message: 'The authentication failed.',
    instruction_text: 'Back to homepage',
    instruction_link: URL_HELPERS.root_path
  }.freeze

  ERROR_NOT_AUTHORIZED = {
    message: 'The user is not authorized.',
    instruction_text: 'Log in with another account',
    instruction_link: URL_HELPERS.authenticate_path
  }.freeze

  # Used in ErrorController#error (/error?type=foo)
  def error_type_object
    mapping = {
      "user_not_authorized" => ERROR_NOT_AUTHORIZED,
      "authentication_failed" => ERROR_AUTHENTICATION_FAILED
    }

    # If the error type from the query is not indicated or listed as one of the error constants,
    # then use the default setting
    mapping.default = ERROR_DEFAULT

    mapping[params[:type]]
  end
end
