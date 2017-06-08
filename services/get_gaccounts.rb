class GetGaccounts
  def initialize(config)
    @config = config
  end

  def call(auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{@config.API_URL}/gaccounts")
    response.code == 200 ? response.parse : nil
  end
end
