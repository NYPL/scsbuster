module ErrorHelper
  # Used in ErrorController#error (/error?type=foo)
  def error_type_object
    case params[:type]
    when 'user_not_authorized'
      { message: 'The user is not authorized.',
        instruction_text: 'Log in with another account',
        instruction_link: authenticate_path }
    when 'authentication_failed'
      {
        message: 'The authentication failed.',
        instruction_text: 'Back to homepage',
        instruction_link: root_path
      }
    else
      {
        message: 'The service is not available now.',
        instruction_text: 'Back to homepage',
        instruction_link: root_path
      }
    end
  end
end
