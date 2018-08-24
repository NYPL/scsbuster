class ErrorController < ApplicationController
  def error
    @is_error_page = true
    @error_message = params[:message].to_s
    @instruction = { message: 'Back to homepage', link: root_path }

    if @error_message === 'user_not_authorized'
      @instruction = { message: 'Log in with another account', link: authenticate_path }
    end
  end
end