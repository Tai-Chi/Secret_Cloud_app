# frozen_string_literal: true

require 'http'

class FindAuthenticatedAccount
  def initialize(config)
    @config = config
  end

  def call(username:, password:)
    response = HTTP.post("#{@config.API_URL}/accounts/authenticate",
                         json: { username: username, passwd: password })
    response.code == 200 ? { username: username } : nil
  end
end
