# frozen_string_literal: true

require 'sinatra'

class FileSystemSyncApp < Sinatra::Base
  
  post '/gaccount/add/?' do
    redirected_if_not_logged_in
    result = AddGaccount.new(settings.config)
                            .call(name: params[:name], auth_token: @auth_token)
    if result
      flash[:notice] = 'Your Google account name has been stored successfully.'
      redirect '/account/info'
    else
      flash[:error] = 'Your Google account name could not be stored. Please try again.'
      redirect '/account/info'
    end
  end

end
