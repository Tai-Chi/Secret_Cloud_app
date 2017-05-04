# frozen_string_literal: true

require 'sinatra'

class FileSystemSyncApp < Sinatra::Base
  get '/account/login/?' do
    if @current_account
      slim :home
    else
      slim :login
    end
  end

  post '/account/login/?' do
    @current_account = FindAuthenticatedAccount.new(settings.config).call(
      username: params[:username], password: params[:password]
    )

    if @current_account
      session[:current_account] = @current_account
      flash[:error] = "Welcome back #{@current_account[:username]}"
      redirect '/'
    else
      flash[:error] = 'Your username or password did not match our records'
      slim :login
    end
  end
end