# frozen_string_literal: true

require 'sinatra'

class FileSystemSyncApp < Sinatra::Base
  
  get '/account/info/?' do
    redirected_if_not_logged_in
    @gaccounts = GetGaccounts.new(settings.config)
                             .call(auth_token: @auth_token)
    slim :account_info
  end

end
