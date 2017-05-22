# frozen_string_literal: true

require 'sinatra'

class FileSystemSyncApp < Sinatra::Base
  get '/account/register/?' do
    if @current_account
      redirect '/'
    else
      slim :register
    end
  end

  post '/account/register/?' do
    if @current_account
      redirect '/'
    else
      if params[:username] == nil || params[:username] == ''
        flash[:error] = 'Username is required'
        redirect '/account/register'
      end

      if params[:email] == nil || params[:email] == ''
        flash[:error] = 'Email is required'
        redirect '/account/register'
      end

      begin
        EmailRegistrationVerification.new(settings.config).call(
          username: params[:username],
          email: params[:email]
        )
        flash[:notice] = 'A verification email has been sent to you. '\
                        'Please check your email.'
        redirect '/'
      rescue => e
        logger.error "FAILED TO SEND EMAIL: #{e}"
        flash[:error] = 'Unable to send email verification -- Sorry, '\
                        'we will recover our system soon.'
        redirect '/account/register'
      end
    end
  end
end
