# frozen_string_literal: true

require 'http'

class AddGaccount
  def initialize(config)
    @config = config
  end

  def call(name:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .post("#{@config.API_URL}/create/gaccount",
                         json: { name: name })
    response.code == 200
  end
end
