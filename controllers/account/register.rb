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

      if params[:password] == nil || params[:password] == ''
        flash[:error] = 'Password is required'
        redirect '/account/register'
      end

      if params[:password_confirm] != params[:password]
        flash[:error] = 'Retyped password does not match'
        redirect '/account/register'
      end

      new_account = CreateAccount.new(settings.config).call(
        username: params[:username], password: params[:password]
      )

      if new_account
        flash[:notice] = "Account #{new_account[:username]} has been created successfully"
        redirect '/'
      else
        flash[:error] = "The username #{params[:username]} has been used by other account"
        slim :register
      end
    end
  end
end
