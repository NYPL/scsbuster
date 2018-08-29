class ErrorController < ApplicationController
  # Render the error page based on the error type
  def error
    # Tell the view this is an error page so the navigation list is not needed
    @is_error_page = true
    # the error type that is passed from the query of the URL
    @current_error_type = params[:type].to_s || ''

    # the instructions based on different error types
    @instruction_general = { message: 'Back to homepage', link: root_path }
    @instruction_user_not_authorized = { message: 'Log in with another account', link: authenticate_path }

    # default error message and instruction
    @error_message = 'The service is not available now.'
    @instruction = @instruction_general
    
    @special_error_type_array = [
      { type: 'user_not_authorized', message: 'The user is not authorized.', instruction: @instruction_user_not_authorized }
    ]

    # Assign the particular message and the instruction if it is a special error type
    @special_error_type_array.each do |e|
      if e[:type] === @current_error_type
        @error_message = e[:message]
        @instruction = e[:instruction]
      end
    end
  end
end