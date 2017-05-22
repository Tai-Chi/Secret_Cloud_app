# frozen_string_literal: true

require 'http'

class CreateVerifiedAccount
  def initialize(config)
    @config = config
  end

  def call(username:, email:, password:)
    response = HTTP.post("#{@config.API_URL}/create/account",
                         json: { username: username,
                                 email: email,
                                 passwd: password })
    response.code == 200
  end
end
