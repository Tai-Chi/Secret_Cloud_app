# frozen_string_literal: true

require 'sinatra'

class FileSystemSyncApp < Sinatra::Base
  get '/account/register/:token_secure/verify/?' do
    @token_secure = params[:token_secure]
    @new_account = SecureMessage.decrypt(@token_secure)

    slim :register_confirm
  end

  post '/account/register/:token_secure/verify/?' do
    redirect "/account/register/#{params[:token_secure]}/verify" if
      (params[:password] != params[:password_confirm]) ||
      params[:password].empty?

    new_account = SecureMessage.decrypt(params[:token_secure])
    result = CreateVerifiedAccount.new(settings.config).call(
      username: new_account['username'],
      email: new_account['email'],
      password: params['password']
    )

    if result
      flash[:notice] = 'Your account has been created successfully.'
      redirect '/account/login'
    else
      flash[:error] = 'Your account could not be created. Please try again.'
      redirect '/account/register'
    end
  end
end
