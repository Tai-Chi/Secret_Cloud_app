require 'sinatra'

class FileSystemSyncApp < Sinatra::Base

  post '/submit/download/?' do

    if params['file'] != nil
      # Find the longest common prefix of names of all source files
      lcp = ""
      min_len = params['file'].min{ |i,j| i.length <=> j.length }.length
      (0...min_len).each do |i|
        col = params['file'].inject(""){ |sum,elem| sum << elem[i] }.squeeze
        break if col.length > 1
        lcp << col
      end

      # Reserve one folder layer
      lcp = lcp.split('/')
      lcp.pop
      lcp = lcp.join('/')

      # Get info of those files to download
      params['file'].each do |file|
        HTTP.post("#{settings.config.API_URL}/download/select",
                  json: { "username": @current_account[:username],
                          "src_path": file,
                          "dst_path": file.sub(lcp,'') }
                 )
        # The variable file here may be a folder or a file. However
        # our server API only supports files, so there is no duplication.
      end
    end

    # Tell the user to open the client software to execute download.
    redirect '/download_reminder.html'
  end
end
