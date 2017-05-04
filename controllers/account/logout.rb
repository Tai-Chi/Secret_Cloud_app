# frozen_string_literal: true

require 'sinatra'

class FileSystemSyncApp < Sinatra::Base
  get '/account/logout/?' do
    @current_account = nil
    session[:current_account] = nil
    flash[:notice] = 'You have logged out - please login again to use this site'
    redirect '/account/login'
  end
end
